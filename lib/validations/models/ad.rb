module Validations
  module Models
    class Ad
      include Dry::Monads[:result]

      OrderSchemaValidator = Dry::Schema.Params do
        required(:title).value(Posting::Types::Title)
        required(:city).value(Posting::Types::City)
        required(:user_id).value(Posting::Types::UserId)
        required(:description).value(Posting::Types::Description)
        optional(:lat).value(Posting::Types::Lat)
        optional(:lon).value(Posting::Types::Lon)
      end

      # @param [Hash] payload
      # @return [Hash]
      def call(payload)
        OrderSchemaValidator.call(payload).to_monad.fmap(&:to_h)
                            .or { |_result| Failure([:invalid_model_validation]) }
      # TODO: add log in case of errors
      end
    end
  end
end
