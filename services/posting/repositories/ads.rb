module Posting
  module Repositories
    class Ads
      include Import[db: "persistence.db"]

      def all
        raw_to_entity(db[:ads].all)
      end

      private

      def raw_to_entity(raw_result)
        raw_result.map do |row|
          Posting::Entities::Ads.new(row)
        end
      end
    end
  end
end
