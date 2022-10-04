Container.register_provider(:faraday) do
  prepare do
    require "faraday"

    conn = Faraday.new do |f|
      f.request :json
      f.response :json, content_type: /\bjson$/
      f.adapter(Faraday.default_adapter)
    end

    register("faraday.connection", conn)
  end
end