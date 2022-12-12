module Posting
  module Types
    include Dry.Types()

    City = String.constrained(max_size: 50)
    UserId = Integer
    Title = String.constrained(min_size: 5)
    Description = String.constrained(max_size: 50)
    Lat = Float
    Lon = Float
  end
end
