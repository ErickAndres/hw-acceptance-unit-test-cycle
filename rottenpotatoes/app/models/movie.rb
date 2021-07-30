class Movie < ActiveRecord::Base
  # how to define class method vs instance method
  
#   def self.others_by_same_director 
#     @movies = Movie.where(:director = movie.director) # right?
#   end
  def self.with_director director
    if !director.nil?
      @movies_with_director = Movie.where(:director => director)
    # not sure if I need another condition 
    #else 
     # fs
    end
  end
end


# how did you do the one with movies with all ratings
