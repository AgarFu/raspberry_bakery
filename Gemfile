# frozen_string_literal: true
source 'https://rubygems.org'

gem 'rake'

group :lint do
  gem 'foodcritic', '~> 3.0'
  gem 'rubocop', '~> 0.18'
  gem 'rubocop-checkstyle_formatter'
end

group :unit, :integration do
  gem 'berkshelf', '~> 5.0'
  gem 'rspec_junit_formatter'
end

group :unit do
  gem 'chefspec', '~> 4.0'
end

group :integration do
  gem 'kitchen-ec2', git: 'git@github.intuit.com:SBG/kitchen-ec2.git', 'tag': 'v1.2.1'
  gem 'kitchen-inspec'
  gem 'kitchen-transport-sshtar'
  gem 'kitchen-vagrant', '~> 0.19'
  gem 'serverspec', '~> 2.0'
  gem 'test-kitchen', git: 'git@github.intuit.com:SBG/test-kitchen.git', 'tag': 'v1.13.2'
end
