# frozen_string_literal: true
# Default attributes for raspberry_bakery

distro = 'jessie'
flavour = 'lite'
version = '2017-01-11'
default['raspberry_bakery']['raspbian']['url'] = "https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_#{flavour}-2017-01-10/#{version}-raspbian-#{distro}-#{flavour}.zip"
default['raspberry_bakery']['raspbian']['distro'] = distro
default['raspberry_bakery']['raspbian']['version'] = version
default['raspberry_bakery']['raspbian']['flavour'] = flavour
default['raspberry_bakery']['raspbian']['checksum'] = '9039b143fda8835f16506e80dad13c461356c5e44cddbe2a56e9b0cdc15d607b'
default['raspberry_bakery']['raspbian']['path'] = '/opt/raspbian'
default['raspberry_bakery']['raspbian']['kernel_url'] = 'https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/kernel-qemu-4.4.34-jessie'
default['raspberry_bakery']['raspbian']['kernel_checksum'] = 'f2a96608a642d7809e3723945020354517eac2d2a56b26af1293274ec2c77563'

default['raspberry_bakery']['centos']['url'] = 'http://mirror.centos.org/altarch/7/isos/armhfp/CentOS-Userland-7-armv7hl-Minimal-1611-RaspberryPi3.img.xz'
default['raspberry_bakery']['centos']['distro'] = 'centos'
default['raspberry_bakery']['centos']['version'] = '7'
default['raspberry_bakery']['centos']['flavour'] = 'minimal'
default['raspberry_bakery']['centos']['checksum'] = 'deb8ec2e74d4cd084a566434652a95bf33c8e4edcb5d4a1e04435a0b6fce9dfb'
default['raspberry_bakery']['centos']['path'] = '/opt/centos'
default['raspberry_bakery']['centos']['kernel_url'] = 'https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/kernel-qemu-4.4.34-jessie'
default['raspberry_bakery']['centos']['kernel_checksum'] = 'f2a96608a642d7809e3723945020354517eac2d2a56b26af1293274ec2c77563'
