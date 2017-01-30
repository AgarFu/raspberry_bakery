# frozen_string_literal: true
require 'rspec/core/rake_task'

# syntax/lint checks: RuboCop & Foodcritic
namespace :lint do # rubocop:disable Metrics/BlockLength
  require 'rubocop/rake_task'
  require 'foodcritic'

  desc 'Run Ruby syntax/lint checks'
  RuboCop::RakeTask.new(:ruby) do |task|
    task.requires = ['rubocop/formatter/checkstyle_formatter']
    task.options = [
      '-c', './.rubocop.yml',
      '--require', 'rubocop/formatter/checkstyle_formatter',
      '--format', 'RuboCop::Formatter::CheckstyleFormatter',
      '--out', 'reports/checkstyle.xml',
      '--format', 'p',
      '--display-cop-names',
      '--extra-details',
      '--display-style-guide'
    ]
    tasks.options << '--no-color' if ENV['user'] == 'jenkins'
    task.fail_on_error = true
  end

  desc 'Run Chef syntax/lint checks'
  FoodCritic::Rake::LintTask.new(:chef) do |task|
    task.options = {
      tags: ['~FC037'],
      fail_tags: ['any']
    }
  end

  desc 'Clean previous linter reports'
  task :clean do
    puts "Cleaning: #{reports}"
    FileUtils.rm_rf(reports) if File.exist?(reports)
  end
end

desc 'Run all syntax/lint checks'
task lint: ['lint:ruby', 'lint:chef']

# unit testing: ChefSpec
desc 'Run RSpec and ChefSpec unit tests'
RSpec::Core::RakeTask.new(:unit) do |rspec|
  rspec.rspec_opts = '--color  --format documentation --format html --out reports/rspec_results.html --format RspecJunitFormatter --out reports/rspec_results.xml'
end

# integration testing: Test Kitchen
namespace :integration do
  require 'kitchen'

  desc 'Run Test Kitchen integration tests with Vagrant'
  task :vagrant do
    Kitchen.logger = Kitchen.default_file_logger
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end
end

desc 'Publish package'
task package: ['package:local']

task default: %w(lint unit)

desc 'Run all integration tests'
task integration: ['integration:vagrant']

desc 'Run all CI validations'
task ci: %w(lint unit integration)

# Default cookbooks task
desc 'Run all jenkins tests'
task jenkins: %w(lint unit)
