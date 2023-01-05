module Posting
  module Models
    class Ad < Sequel::Model
      def validate
        super
        result = Container["validations.models.ad"].call(values)
        errors.add(:invalid_model_validation) unless result.success?
      end

      def to_json(*a)
        to_hash.to_json(*a)
      end
    end
  end
end
