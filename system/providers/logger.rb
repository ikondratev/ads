Container.register_provider(:logger) do
  prepare do
    logger = System::AppLogger.new(mode: ENV["RACK_ENV"]).instance
    register("app.logger", logger)
  end
end