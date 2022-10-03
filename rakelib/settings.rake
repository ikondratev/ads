task :settings do
  require "config"
  require_relative "../config/boot"
end

task default: %i[linters:rubocop]