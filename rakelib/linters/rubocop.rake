namespace :linters do
  desc "Run linters"
  require "rubocop/rake_task"

  RuboCop::RakeTask.new(:rubocop) do |task|
    task.fail_on_error = true
    task.requires << "rubocop-rake"
  end
end