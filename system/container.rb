require "dry/system/container"
require "dry/system/loader/autoloading"
require "zeitwerk"

class Container < Dry::System::Container
  use :env, inferrer: -> { ENV.fetch("APP_ENV", :development).to_sym }
  use :zeitwerk

  configure do |config|
    config.component_dirs.add "services" do |dir|
      dir.memoize = true

      dir.namespaces.add "ads", key: "services.ads"
    end

    config.component_dirs.add "apps" do |dir|
      dir.memoize = true

      dir.namespaces.add "http", key: "http"
    end
  end
end

Import = Container.injector