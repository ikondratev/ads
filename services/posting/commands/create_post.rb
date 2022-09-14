module Posting
  module Commands
    class CreatePost
      include Dry::Monads[:result, :do]

      include Import[ads_repo: "services.posting.repositories.ads"]

      def call(title, city, user_id, description)
        post = {
          title: title,
          city: city,
          description: description,
          user_id: user_id
        }
        ads_repo.create(post)
        Success(abs)
      end
    end
  end
end
