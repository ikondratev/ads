module Validations
  class UpdateCoordinates
    include Dry::Monads[:result]

    OrderSchemaValidator = Dry::Schema.Params do
      required(:lat).value(Posting::Types::Lat)
      required(:lon).value(Posting::Types::Lon)
      required(:post_id).value(Types::PostId)
    end

    # @param [Hash] payload
    # @return [Hash]
    def call(payload)
      OrderSchemaValidator.call(prepare_params(payload)).to_monad.fmap(&:to_h)
                          .or { |_result| Failure([:invalid_payload]) }
    end

    private

    def prepare_params(payload)
      {
        lat: payload[:lat],
        lon: payload[:lon],
        post_id: payload[:post_id]
      }
    end
  end
end
