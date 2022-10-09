module HTTP
  module Actions
    module Handlers
      class Errors
        include Import[i18n: "locales.i18n"]
        def call(result)
          case result.failure[0]
          when :forbidden_error
            { code: 403, error: { error_message: i18n.t(:forbidden, scope: "api.errors.request") } }
          when :bad_request
            { code: 404, error: { error_message: i18n.t(:bad_request, scope: "api.errors.request") } }
          when :invalid_payload
            { code: 422, error: { error_message: i18n.t(:validation_error, scope: "api.errors.request") } }
          when :creation_error
            { code: 503, error: { error_message: i18n.t(:creation_error, scope: "services.errors") } }
          when :show_error
            { code: 503, error: { error_message: i18n.t(:show_error, scope: "services.errors") } }
          else
            { code: 500, error: { error_message: i18n.t(:unexpected_error, scope: "backend.errors.request") } }
          end
        end
      end
    end
  end
end
