Container.register_provider(:db) do
  prepare do
    require "sequel"

    db = Sequel.postgres(ENV["CONNECT_CREDENTIALS"])

    register("persistence.db", db)
  end
end