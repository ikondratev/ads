require "rubygems"
require "rake"

desc "Run spec"
task default: %i[rubocop]

desc "Linter"
require "rubocop/rake_task"

RuboCop::RakeTask.new do |task|
  task.fail_on_error = true
  task.requires << "rubocop-rake"
end

# require 'bundler/gem_tasks'
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

namespace :db do
  require "sequel"
  require "dotenv"

  Dotenv.load(".env.prod", ".env.local")

  Sequel.extension :migration
  DB = ENV["MODE"] == "prod" ? Sequel.connect(ENV["DATABASE_URL"]) : Object

  desc "Prints current schema version"
  task :version do
    version = DB.tables.include?(:schema_migrations) ? DB[:schema_migrations].first : 0

    puts "Schema Version: #{version}"
  end

  desc "Prints current schema version"
  task :migrate do
    Sequel::Migrator.run(DB, "./db/migrations")
    Rake::Task["db:version"].execute
  end

  desc "Perform rollback to specified target or full rollback as default"
  task :rollback, :target do |t, args|
    args.with_defaults(:target => 0)

    Sequel::Migrator.run(DB, "./db/migrations", :target => args[:target].to_i)
    Rake::Task["db:version"].execute
  end

  desc "Perform migration reset (full rollback and migration)"
  task :reset do
    Sequel::Migrator.run(DB, "./db/migrations", :target => 0)
    Sequel::Migrator.run(DB, "./db/migrations")
    Rake::Task["db:version"].execute
  end
end
