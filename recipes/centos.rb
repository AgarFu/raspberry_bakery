# frozen_string_literal: true
#
# Cookbook Name:: raspberry_bakery
# Recipe:: centos
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

centos_info = node['raspberry_bakery']['centos']
centos_filename = "#{centos_info['version']}-centos-#{centos_info['distro']}-#{centos_info['flavour']}.img"
centos_xz = "#{centos_filename}.xz"
centos_kernel = File.basename(URI.parse(centos_info['kernel_url']).path)
centos_mount_point = '/mnt/centos'
directory centos_mount_point

directory centos_info['path']

remote_file "#{centos_info['path']}/#{centos_xz}" do
  source node['raspberry_bakery']['centos']['url']
  checksum node['raspberry_bakery']['centos']['checksum']
  action :create
end

remote_file "#{centos_info['path']}/#{centos_kernel}" do
  source node['raspberry_bakery']['centos']['kernel_url']
  checksum node['raspberry_bakery']['centos']['kernel_checksum']
  action :create
end

execute "Uncompress #{centos_xz}" do
  command "/bin/xzcat ./#{centos_xz} > ./#{centos_filename}"
  cwd centos_info['path']
  creates  "#{centos_info['path']}/#{centos_filename}"
  notifies :mount, "mount[#{centos_mount_point}]", :immediately
end

ruby_block 'get offset centos' do
  block do
    cmdline = "/usr/sbin/fdisk -l #{centos_filename}|grep ^#{centos_info['version']}-centos-#{centos_info['distro']}-#{centos_info['flavour']}|tr -s ' ' '#'|cut -f 2 -d '#'|tail -n 1"
    get_offset = Mixlib::ShellOut.new(cmdline, :cwd => centos_info['path'])
    get_offset = get_offset.run_command
    node.default['raspberry_bakery']['centos']['image_offset'] = get_offset.stdout.to_i
  end
  action :nothing
end

mount centos_mount_point do
  device "#{centos_info['path']}/#{centos_filename}"
  options lazy { "loop,offset=#{512 * node['raspberry_bakery']['centos']['image_offset']}" }
  action :nothing
  notifies :run, 'ruby_block[get offset centos]', :before
  #  notifies :create, "file[#{centos_mount_point}/boot/ssh]",:immediately
  #  notifies :create, "template[#{centos_mount_point}/etc/fstab]",:immediately
  #  notifies :create, "template[#{centos_mount_point}/etc/ld.so.preload]",:immediately
end

mount "umount #{centos_mount_point}" do
  mount_point centos_mount_point
  device "#{centos_info['path']}/#{centos_filename}"
  action :nothing
  notifies :create, "template[#{centos_info['path']}/raspberry_packer.json]", :immediately
end

file "#{centos_mount_point}/boot/ssh" do
  action :nothing
  notifies :umount, "mount[umount #{centos_mount_point}]", :delayed
end

template "#{centos_mount_point}/etc/ld.so.preload" do
  source 'centos/ld.so.preload.erb'
  action :nothing
  notifies :umount, "mount[umount #{centos_mount_point}]", :delayed
end

template "#{centos_mount_point}/etc/fstab" do
  source 'centos/fstab.erb'
  action :nothing
  notifies :umount, "mount[umount #{centos_mount_point}]", :delayed
end

template "#{centos_info['path']}/raspberry_packer.json" do
  source 'raspberry_packer.json.erb'
  variables(lazy do
    {
      :centos_filename => "#{centos_info['path']}/#{centos_filename}",
      :centos_sum => Digest::MD5.file("#{centos_info['path']}/#{centos_filename}").hexdigest,
      :centos_kernel => "#{centos_info['path']}/#{centos_kernel}"
    }
  end)
  action :nothing
end
