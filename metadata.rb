# frozen_string_literal: true
name 'raspberry_bakery'
maintainer 'Rene martin'
maintainer_email '<agarfu@gmail.com>'
license 'MIT'
description 'Installs/Configures raspberry_bakery'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

depends 'packer'
depends 'yum-epel'
