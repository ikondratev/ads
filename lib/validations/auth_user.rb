module Validations
  class AuthUser
    include Dry::Monads[:result]

    OrderSchemaValidator = Dry::Schema.Params do
      required(:token).value(Types::TokenBarier)
    end

    def call(payload)
      OrderSchemaValidator.call(prepare_params(payload)).to_monad.fmap(&:to_h)
                          .or { |_result| Failure([:invalid_payload]) }
    end

    private

    def prepare_params(payload)
      {
        token: payload[:barier]
      }
    end
  end
end
