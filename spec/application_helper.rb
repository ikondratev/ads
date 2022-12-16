require "spec_helper"

ENV["RACK_ENV"] ||= "test"

require_relative "../config/boot"

abort("You run tests in production mode. Please don't do this!") if ENV["RACK_ENV"] == :production
Dir[File.expand_path("", __dir__).concat("/spec/support/**/*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  config.include Dry::Monads[:result, :try]
  config.include Rack::Test::Methods
end
