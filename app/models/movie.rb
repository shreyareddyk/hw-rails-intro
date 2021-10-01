class Movie < ActiveRecord::Base

    def self.all_ratings #get all ratings
      select(:rating).map(&:rating).uniq # get all unique ratings
    end
    
    def self.with_ratings(ratings) 
        Movie.where(rating:ratings) #filter and remember by the rating and the sorted column respectively
    end
    
end