require 'rails_helper'

if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end

describe MoviesController do
  describe '#show_same_director' do
    it 'has a director' do 
      same_director_movies = ['Django', 'Tarantino']
      movie = Movie.create(:id => '1', :title => 'Django', :director => 'Tarantino')
      allow(Movie).to receive(:with_director).with('Tarantino')
     .and_return(same_director_movies)
      get :show_same_director, {id: 1, show_same_director: same_director_movies}
      expect(response).to render_template(:show_same_director)
    end

    it 'has no director' do
      same_director_movies = []
      movie = Movie.create(:id => '2', :title => 'Titanic')
      allow(Movie).to receive(:with_director).with('')
     .and_return(same_director_movies)
      get :show_same_director, {id: 2, show_same_director: same_director_movies}
      expect(response).to redirect_to(movies_path)
    end
  end
end