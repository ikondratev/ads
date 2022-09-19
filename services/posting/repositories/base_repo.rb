module Posting
  module Repositories
    class BaseRepo
      protected

      # @param [Hash] raw_result
      # @param [Class] entity
      # @return [Array<Class>]
      def raw_to_entity(raw_result, entity)
        raw_result.map do |row|
          entity.new(row)
        end
      end

      # @return [Hash] params
      def time_stamp
        {
          created_at: Time.now,
          updated_at: Time.now
        }
      end
    end
  end
end
