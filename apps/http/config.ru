require "bundler/setup"
require "././config/boot"

run Container["http.ads_controller"]
