module Validations
  class CreatePayload
    include Dry::Monads[:result]

    OrderSchemaValidator = Dry::Schema.Params do
      required(:title).value(Posting::Types::Title)
      required(:city).value(Posting::Types::City)
      required(:user_id).value(Posting::Types::UserId)
      required(:description).value(Posting::Types::Description)
    end

    # @param [Hash] payload
    # @return [Hash]
    def call(payload)
      OrderSchemaValidator.call(payload).to_monad.fmap(&:to_h)
                          .or { |_result| Failure([:invalid_payload]) }
    end
  end
end
