namespace :db do
  desc "Run init seeds"
  task :seeds, %i[version] => :settings do
    require_relative "../../config/environment"
    require "sequel/core"
    require "sequel/extensions/seed"
    Sequel.extension :seed

    DB = Sequel.connect(Settings.db.to_hash)
    seeds_path = File.expand_path("../../db/seeds", __dir__)
    Sequel::Seeder.apply(DB, seeds_path)
  end
end