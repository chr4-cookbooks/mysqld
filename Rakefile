#!/usr/bin/env rake

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:unit) do |t|
  t.pattern = ['test/unit/**/*_spec.rb']
end

require 'foodcritic'
FoodCritic::Rake::LintTask.new do |t|
  t.options = { fail_tags: ['any'] }
end

require 'cookstyle'
require 'rubocop/rake_task'
RuboCop::RakeTask.new do |task|
  task.options << '--display-cop-names'
end

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
end

task default: [:foodcritic, :rubocop]
