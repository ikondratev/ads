require "dry/system/container"
require "dry/system/loader/autoloading"
require "zeitwerk"

class Container < Dry::System::Container
  use :env, inferrer: -> { ENV.fetch("APP_ENV", :development).to_sym }
  use :zeitwerk

  configure do |config|
    config.component_dirs.add "posts" do |dir|
      dir.memoize = true

      dir.namespaces.add "posts", key: "services.posts"
    end
  end
end

Import = Container.injector