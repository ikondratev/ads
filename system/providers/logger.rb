Container.register_provider(:logger) do
  prepare do
    require "rack/ougai"

    root_path = File.expand_path("../..", __dir__)
    logger = Ougai::Logger.new(
      root_path.concat("/", Settings.log.path),
      level: Settings.log.level
    )

    logger.before_log = lambda do |data|
      data[:service] = { name: Settings.app.name }
      data[:request_id] ||= Thread.current[:request_id]
    end

    register("app.logger", logger)
  end
end