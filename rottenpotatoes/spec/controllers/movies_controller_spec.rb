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
      expect(flash[:warning]).to match(/has no director info/)
      expect(response).to redirect_to(movies_path)
    end
  end
  
  describe '#show' do 
    let!(:movie) {FactoryBot.create(:movie)}
    it 'shows movies page' do 
        get :show, id: movie.id
        expect(response).to render_template(:show)
    end
  end
  
  describe '#index' do 
    let!(:movie) {FactoryBot.create(:movie)}
    it 'shows movies page' do 
        get :index
        expect(response).to render_template(:index)
    end
  end
  
  describe '#create' do 
    let!(:movie) {FactoryBot.create(:movie)}
    it 'creates movie and redirects to movies page' do 
        post :create, movie: FactoryBot.attributes_for(:movie)
        expect(response).to redirect_to(movies_url)
    end
  end
  
  describe '#edit' do 
    let!(:movie) {FactoryBot.create(:movie)}
    it 'edit movie in edit page' do 
        get :edit, id: movie.id
        expect(response).to render_template(:edit)
    end
  end
  
  describe '#update' do 
    let!(:movie) {FactoryBot.create(:movie)}
    let(:new_attributes) {
      { title: "Superman1" }
    }
    it 'shows movies page' do 
        put :update, id: movie.id, movie: new_attributes
        expect(response).to redirect_to(movie_path(movie))
    end
  end
  
  describe '#destroy' do 
    let!(:movie) {FactoryBot.create(:movie)}
    it 'shows movies page' do 
        delete :destroy, id: movie.id
        expect(response).to redirect_to(movies_path)
    end
  end
end