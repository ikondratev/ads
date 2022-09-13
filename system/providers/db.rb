Container.register_provider(:db) do
  prepare do
    require "sequel"

    db = ENV["MODE"] == "prod" ? Sequel.connect(ENV["CONNECT_CREDENTIALS"]) : Object

    register("persistence.db", db)
  end
end