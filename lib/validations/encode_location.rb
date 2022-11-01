module Validations
  class EncodeLocation
    include Dry::Monads[:result]

    OrderSchemaValidator = Dry::Schema.Params do
      required(:city).value(Types::City)
    end

    def call(payload)
      OrderSchemaValidator.call(prepare_params(payload)).to_monad.fmap(&:to_h)
                          .or { |_result| Failure([:invalid_payload]) }
    end

    private

    def prepare_params(payload)
      {
        city: payload[:city]
      }
    end
  end
end
