require "dry/system/container"
require "dry/system/loader/autoloading"
require "zeitwerk"
require "dry-types"
require "dry/types"
Dry::Types.load_extensions(:monads)
require "dry/schema"
require "dry-schema"
Dry::Schema.load_extensions(:monads)
require "dry-struct"
require "dry/monads"
require "dry/monads/do"
require "bunny"

class Container < Dry::System::Container
  use :env, inferrer: -> { ENV.fetch("APP_ENV", :development).to_sym }
  use :zeitwerk

  configure do |config|
    config.component_dirs.add "services" do |dir|
      dir.memoize = true

      dir.namespaces.add "posting", key: "services.posting"
    end

    config.component_dirs.add "lib" do |dir|
      dir.memoize = true

      dir.namespaces.add "validations", key: "validations"
      dir.namespaces.add "auth_service", key: "auth_service"
      dir.namespaces.add "geocoder_service", key: "geocoder_service"
    end

    config.component_dirs.add "apps" do |dir|
      dir.memoize = true

      dir.namespaces.add "http", key: "http"
    end
  end
end

Import = Container.injector