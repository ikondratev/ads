module Validations
  class CreatePayload
    include Dry::Monads[:result]

    OrderSchemaValidator = Dry::Schema.Params do
      required(:title).value(Posting::Types::Title)
      required(:city).value(Posting::Types::String)
      required(:user_id).value(Posting::Types::UserId)
      required(:description).value(Posting::Types::Description)
    end

    def call(payload)
      OrderSchemaValidator.call(prepare_params(payload)).to_monad.fmap(&:to_h)
                          .or { |_result| Failure([:invalid_payload]) }
    end

    private

    def prepare_params(payload)
      {
        title: payload[:title],
        city: payload[:city],
        description: payload[:description],
        user_id: payload[:user_id]
      }
    end
  end
end
