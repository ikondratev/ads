module HTTP
  module Actions
    module Handlers
      class Errors
        def call(result)
          case result.failure[0]
          when :invalid_payload
            { code: 422, error: { scope: "api.errors", error_message: result.failure[1][:error_message] } }
          when :creation_error
            { code: 503, error: { scope: "api.errors", error_message: result.failure[1][:error_message] } }
          when :show_error
            { code: 503, error: { scope: "api.errors", error_message: result.failure[1][:error_message] } }
          else
            { code: 500, error: { scope: "backend.errors", error_message: "internal error" } }
          end
        end
      end
    end
  end
end
