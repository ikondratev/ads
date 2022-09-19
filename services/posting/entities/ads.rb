module Posting
  module Entities
    class Ads < Dry::Struct
      transform_keys(&:to_sym)

      attribute :id, Posting::Types::Integer

      attribute :title, Posting::Types::Title
      attribute :description, Posting::Types::Description
      attribute :user_id, Posting::Types::UserId
      attribute :city, Posting::Types::String
      attribute :lat, Posting::Types::Float.optional
      attribute :lon, Posting::Types::Float.optional

      def to_json(*a)
        to_h.to_json(*a)
      end
    end
  end
end
