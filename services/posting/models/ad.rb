module Posting
  module Models
    class Ad < Sequel::Model
      include Import[
                i18n: "locales.i18n",
                model_validation: "validations.models.ad"
              ]

      def validate
        super
        result = model_validation.call(values)
        errors.add(:invalid_model_validation) unless result.success?
      end

      def to_json(*a)
        to_hash.to_json(*a)
      end
    end
  end
end
