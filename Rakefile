require 'rubygems'
require 'rake'

desc 'Run spec'
task default: %i[rubocop]

desc 'Linter'
require 'rubocop/rake_task'
RuboCop::RakeTask.new do |task|
  task.fail_on_error = true
  task.requires << 'rubocop-rake'
end