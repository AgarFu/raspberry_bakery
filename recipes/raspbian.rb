# frozen_string_literal: true
#
# Cookbook Name:: raspberry_bakery
# Recipe:: raspbian
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

raspbian_info = node['raspberry_bakery']['raspbian']
raspbian_filename = "#{raspbian_info['version']}-raspbian-#{raspbian_info['distro']}-#{raspbian_info['flavour']}.img"
raspbian_zip = "#{raspbian_filename}.zip"
raspbian_kernel = File.basename(URI.parse(raspbian_info['kernel_url']).path)
raspbian_mount_point = '/mnt/raspbian'
directory raspbian_mount_point

directory raspbian_info['path']

remote_file "#{raspbian_info['path']}/#{raspbian_zip}" do
  source node['raspberry_bakery']['raspbian']['url']
  checksum node['raspberry_bakery']['raspbian']['checksum']
  action :create
end

remote_file "#{raspbian_info['path']}/#{raspbian_kernel}" do
  source node['raspberry_bakery']['raspbian']['kernel_url']
  checksum node['raspberry_bakery']['raspbian']['kernel_checksum']
  action :create
end

execute "Unzip #{raspbian_zip}" do
  command "/usr/bin/unzip ./#{raspbian_zip}"
  cwd raspbian_info['path']
  creates  "#{raspbian_info['path']}/#{raspbian_filename}"
  notifies :mount, "mount[#{raspbian_mount_point}]", :immediately
end

ruby_block 'get offset' do
  block do
    cmdline = "/usr/sbin/fdisk -l #{raspbian_filename}|grep ^#{raspbian_info['version']}-raspbian-#{raspbian_info['distro']}-#{raspbian_info['flavour']}|tr -s ' ' '#'|cut -f 2 -d '#'|tail -n 1"
    get_offset = Mixlib::ShellOut.new(cmdline, :cwd => raspbian_info['path'])
    get_offset = get_offset.run_command
    node.default['raspberry_bakery']['raspbian']['image_offset'] = get_offset.stdout.to_i
  end
  action :nothing
end

mount raspbian_mount_point do
  device "#{raspbian_info['path']}/#{raspbian_filename}"
  options lazy { "loop,offset=#{512 * node['raspberry_bakery']['raspbian']['image_offset']}" }
  action :nothing
  notifies :run, 'ruby_block[get offset]', :before
  notifies :create, "file[#{raspbian_mount_point}/boot/ssh]", :immediately
  notifies :create, "template[#{raspbian_mount_point}/etc/fstab]", :immediately
  notifies :create, "template[#{raspbian_mount_point}/etc/ld.so.preload]", :immediately
end

mount "umount #{raspbian_mount_point}" do
  mount_point raspbian_mount_point
  device "#{raspbian_info['path']}/#{raspbian_filename}"
  action :nothing
  notifies :create, "template[#{raspbian_info['path']}/raspberry_packer.json]", :immediately
end

file "#{raspbian_mount_point}/boot/ssh" do
  action :nothing
  notifies :umount, "mount[umount #{raspbian_mount_point}]", :delayed
end

template "#{raspbian_mount_point}/etc/ld.so.preload" do
  source 'raspbian/ld.so.preload.erb'
  action :nothing
  notifies :umount, "mount[umount #{raspbian_mount_point}]", :delayed
end

template "#{raspbian_mount_point}/etc/fstab" do
  source 'raspbian/fstab.erb'
  action :nothing
  notifies :umount, "mount[umount #{raspbian_mount_point}]", :delayed
end

template "#{raspbian_info['path']}/raspberry_packer.json" do
  source 'raspberry_packer.json.erb'
  variables(lazy do
    {
      :raspbian_filename => "#{raspbian_info['path']}/#{raspbian_filename}",
      :raspbian_sum => Digest::MD5.file("#{raspbian_info['path']}/#{raspbian_filename}").hexdigest,
      :raspbian_kernel => "#{raspbian_info['path']}/#{raspbian_kernel}"
    }
  end)
  action :nothing
end
