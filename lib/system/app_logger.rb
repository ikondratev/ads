require "rack/ougai"

module System
  class AppLogger
    attr_reader :instance

    PROD_ENV = %w[production].freeze

    # @param [String] mode, default: development
    # @return [Ougai::Logger] instance
    def initialize(mode: "development")
      @mode = mode
      @instance = PROD_ENV.include?(mode) ? prod_mode : debug_mode
    end

    private

    def prod_mode
      root_path = File.expand_path("../..", __dir__)

      logger = Ougai::Logger.new(
        root_path.concat("/", Settings.log.path),
        level: Settings.log.level
      )

      logger.before_log = lambda do |data|
        data[:app_mode] = @mode
        data[:service] = { name: Settings.app.name }
        data[:request_id] ||= Thread.current[:request_id]
      end

      logger
    end

    def debug_mode
      logger = Ougai::Logger.new(STDOUT)
      logger.formatter = Ougai::Formatters::Readable.new

      logger.before_log = lambda do |data|
        data[:app_mode] = @mode
        data[:service] = { name: Settings.app.name }
        data[:request_id] ||= Thread.current[:request_id]
      end

      logger
    end
  end
end