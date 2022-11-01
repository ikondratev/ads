Container.register_provider(:db) do
  prepare do
    require "sequel"

    AVAILABLE_ENV = %w[production development].freeze

    db = AVAILABLE_ENV.include?(ENV["RACK_ENV"]) ? Sequel.connect(Settings.db.to_h) : Object

    register("persistence.db", db)
  end
end