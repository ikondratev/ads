require "rubygems"
require "bundler/setup"
require "././config/boot"

use Rack::Ougai::LogRequests, Container["app.logger"]
use System::RequestId

run Container["http.ads_controller"]
