class Movie < ActiveRecord::Base
  def self.find_by_rating(ratings)
    where(rating: ratings)
    # where("rating IN (?)", ratings)
  end
end
