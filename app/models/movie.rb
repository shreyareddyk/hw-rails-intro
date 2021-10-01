class Movie < ActiveRecord::Base

    def self.all_ratings
      return ['G', 'PG', 'PG-13' ,'R'] #collection of movie ratings
    end
    
    def self.with_ratings(ratings)
        if ratings.nil? #when no rating is checked
            Movie.all
        else #filtering by rating passed as param
            Movie.where(rating:ratings)
        end
    end
end