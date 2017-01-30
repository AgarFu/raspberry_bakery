# frozen_string_literal: true
#
# Cookbook Name:: raspberry_bakery
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

include_recipe 'yum-epel'
# Installing qemu
%w(qemu-kvm qemu-img qemu-system-arm zip unzip nmap vim).each do |pkg|
  package pkg
end

include_recipe 'packer'
