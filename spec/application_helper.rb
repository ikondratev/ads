require "spec_helper"

ENV["RACK_ENV"] ||= "test"

require_relative "../config/boot"

abort("You run tests in production mode. Please don't do this!") if ENV["RACK_ENV"] == :production
Dir[File.expand_path("./spec/support/**/*.rb", __dir__)].sort.each  { |f| require f }

require "support/client_helpers"

RSpec.configure do |config|
  config.include Dry::Monads[:result, :try]
  config.include ClientHelpers, type: :client
  config.include Rack::Test::Methods
end
