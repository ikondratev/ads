namespace :tests do
  desc "Run specs"
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:spec)
end