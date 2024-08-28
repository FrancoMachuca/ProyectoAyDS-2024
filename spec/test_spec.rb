ENV['APP_ENV'] = 'test'

require_relative '../myapp.rb'
require 'rspec'
require 'rack/test'
require './models/level'

RSpec.describe 'The Server' do
  include Rack::Test::Methods

  def app
    # Sinatra::Appplication
    MyApp.new
  end


  context "when logged out" do
    before(:each) do
      get '/logout'
      follow_redirect!
    end

    it "redirects to the login page correctly when no other route is specified" do
      get '/'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it "loads the login page correctly" do
      get '/login'
      expect(last_response).to be_ok
    end

    it "loads the registration page correctly" do
      get '/registro'
      expect(last_response).to be_ok
    end

    it "redirects to the login page when trying to access the level selection page while not logged in" do
      get '/jugar'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it "redirects to the login page when trying to access the profile info page while not logged in" do
      get '/perfil'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it "redirects to the login page when trying to access the ranking page while not logged in" do
      get '/ranking'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it "redirects to login page when trying to play a level while not logged in" do
      get '/level/1'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end


    it "redirects to login page when trying to access a question while not logged in" do
      get'/level/1/1'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end


    it "redirects to login page when trying to answer a question while not logged in" do
      post '/level/1/1/check'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it "shows an error message if log in credentials are incorrect" do
      post '/login', name: 'Homero Simpson', password: 'callefalsa123'
      expect(last_response.body).to include("Nombre de usuario o contraseña son incorrectas")
    end
  end

  context "when logged in" do
    before(:each) do
      get '/logout'
      post '/login', name: 'Valentino Natali', password: '123'
    end

    it "shows the level selection page" do
      get '/jugar'
      expect(last_response).to be_ok
      expect(last_request.path).to eq("/jugar")
    end

    it "shows the level page when trying to play it from the level selection page" do
      level = Level.first
      get "/level/#{level.id}"
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq("/level/#{level.id}/#{level.questions.first.id}")
    end

    it "allows users to log out" do
      get '/logout'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq("/login")
    end

    it "shows the ranking page" do
      get '/ranking'
      expect(last_response).to be_ok
    end

    it "shows the profile page correctly" do
      get '/perfil'
      expect(last_response).to be_ok
    end

    it "doesn't allow to play locked levels" do
      get '/level/2'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq("/jugar")
    end
  end

  context "playing" do
    before(:each) do
      get '/logout'
      u = User.new(name: 'Homero Simpson', password: 'callefalsa123', mail: 'hs@example.com')
      u.save
      i = 1
      while i <= 6
        UserLevel.create(user: u, level: Level.find(i), userLevelScore: 500)
        i += 1
      end
      post '/login', name: 'Homero Simpson', password: 'callefalsa123'
      follow_redirect!
    end

    after(:each) do
      User.find_by(name: 'Homero Simpson').destroy
    end

    it "enters to a level correctly" do
      get '/level/1'
      follow_redirect!
      expect(last_response).to be_ok
    end

    it "unlocks exams correctly" do
      u = User.find_by(name: 'Homero Simpson')
      UserLevel.destroy_by(user: u, level: Level.find(6), userLevelScore: 500)
      gm = GameDataManager.new
      gm.unlockNextLevelFor(user: u, possiblyCompleted: Level.find(5))
      get '/level/6'
      follow_redirect!
      expect(last_request.path).to eq('/level/6/21')
    end

    it "unlocks levels correctly" do
      u = User.find_by(name: 'Homero Simpson')
      UserLevel.destroy_by(user: u, level: Level.find(6))
      UserLevel.destroy_by(user: u, level: Level.find(5))
      gm = GameDataManager.new
      gm.unlockNextLevelFor(user: u, possiblyCompleted: Level.find(4))
      get '/level/5'
      follow_redirect!
      expect(last_request.path).to eq('/level/5/17')
    end

    it "enters to an exam correctly" do
      get '/level/6'
      follow_redirect!
      expect(last_response). to be_ok
    end

    it "shows the profile page correctly" do
      get '/perfil'
      expect(last_response).to be_ok
    end

    it "doesn't unlock a level without having beaten the previous one first" do
      u = User.find_by(name: 'Homero Simpson')
      UserLevel.destroy_by(user: u, level: Level.find(6))
      UserLevel.destroy_by(user: u, level: Level.find(5))
      gm = GameDataManager.new
      gm.unlockNextLevelFor(user: u, possiblyCompleted: Level.find(5))
      get '/level/6'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq("/jugar")
    end
  end

  context "registration" do
    before(:each) do
      get '/logout'
    end

    after(:each) do
      User.find_by(name: 'Homero Simpson').destroy
    end

    it "registers a new user correctly" do
      post '/registro', name: 'Homero Simpson', password: 'callefalsa123', mail: 'hs@example.com'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end
    
    it "shows an error if the user already exists" do
      User.create(name: 'Homero Simpson', password: 'callefalsa123', mail: 'hs@example.com')
      post '/registro', name: 'Homero Simpson', password: 'callefalsa123', mail: 'hs@example.com'
      expect(last_response).to_not be_redirect
    end
  end
end