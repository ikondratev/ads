module Posting
  module Repositories
    class AdsRepo < BaseRepo
      include Import[db: "persistence.db"]

      def all
        raw_to_entity(db[:ads].all, Posting::Entities::Ads)
      end

      def create(post)
        db[:ads].insert(post.merge!(time_stamp))
      end
    end
  end
end
