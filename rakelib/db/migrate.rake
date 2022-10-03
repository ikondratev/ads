namespace :db do
  desc "Run database migrations"
  task :migrate, %i[version] => :settings do |t, args|
    require "sequel/core"
    Sequel.extension :migration

    Sequel.connect(Settings.db.to_hash) do |db|
      db.extension :schema_dumper
      migrations = File.expand_path("../../db/migrations", __dir__)
      version = args.version.to_i if args.version
      filename = "db/schema.rb"

      Sequel::Migrator.run(db, migrations, target: version)

      File.open filename, 'w' do |file|
        file << db.dump_schema_migration(same_db: true)
      end
    end
  end
end