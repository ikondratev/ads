Container.register_provider(:db) do
  prepare do
    require "sequel"

    AVAILABLE_ENV = %w[prod local].freeze

    db = AVAILABLE_ENV.include?(ENV["MODE"]) ? Sequel.connect(ENV["DATABASE_URL"]) : Object

    register("persistence.db", db)
  end
end