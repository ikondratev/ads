module Posting
  module Repositories
    class AdsRepo < BaseRepo
      include Import[db: "persistence.db"]

      def all
        raw_to_entity(db[:ads].all, Posting::Entities::Ads)
      end

      def find_by_id(id)
        db[:ads].first(id: id)
      end

      def create(post)
        db[:ads].insert(post.merge!(time_stamp))
      end

      def update_by_id(id, data)
        db[:ads].where(id: id).update(data)
      end
    end
  end
end
