require 'rails_helper'

#describe 'movies return correct matches by the same director'
describe Movie do
  describe "#with_director" do 
    it "finds movies with same director" do 
      movie1 = Movie.create(:title => 'Django', :director => 'Tarantino')
      movie2 = Movie.create(:title => 'Pulp Fiction', :director => 'Tarantino')
      expect(Movie.with_director(movie1.director)).to include(movie2)
    end 
    it "finds no matches of movies by different directors" do 
      movie1 = Movie.create(:title => 'Django', :director => 'Tarantino')
      movie2 = Movie.create(:title => 'Black Panther', :director => 'Coogler')
      expect(Movie.with_director(movie1.director)).not_to include(movie2)
    end
  end
end
