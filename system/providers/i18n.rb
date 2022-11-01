Container.register_provider(:i18n) do |container|
  prepare do
    require "I18n"

    root_path = File.expand_path("../..", __dir__)
    I18n.load_path += Dir[File.join(root_path, "/config/locales/**/*.yml")]
    I18n.available_locales = %i[en ru]
    I18n.default_locale = :ru

    register("locales.i18n", I18n)
  end
end