require "config"

ENV["RACK_ENV"] ||= "development"

Config.setup do |config|
  config.use_env = true
  config.env_prefix = "ENV"
  config.env_separator = "__"
end

setting_files = Config.setting_files(
  File.expand_path("../config", __dir__),
  ENV["RACK_ENV"]
)

Config.load_and_set_settings(setting_files)

require "dry/initializer"
require "./system/container"
require "./config/initializers/consumer"
require "./config/initializers/connection"
Container.finalize!
