ENV['APP_ENV'] = 'test'

require_relative '../myapp.rb'
require 'rspec'
require 'rack/test'
require './models/level'

RSpec.describe 'The Server' do
  include Rack::Test::Methods

  def app
    # Sinatra::Application
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

  context "questionsManager" do
    let(:qm) { QuestionsManager.new }
    let(:level) { Level.create}
    let(:question1) { Question.new(questionable_type: "Multiple_choice", level: level) }
    let(:question2) { Question.create(description: "prueba1", questionable_type: "Translation", level: level) }
    let(:question3) { Question.create(description: "prueba2", questionable_type: "To_complete", level: level) }
    let(:question4) { Question.create(description: "prueba3", questionable_type: "MouseTranslation", level: level) }

    before do
      level.questions.push(question2)
      level.questions.push(question3)
      level.questions.push(question4)
    end

    describe "#show" do
      it "shows multiple_choice view" do
        expect(qm.show(question: question1)).to eq(:multiple_choice)
      end

      it "shows translation view" do
        expect(qm.show(question: question2)).to eq(:translation)
      end

      it "shows to_complete view" do
        expect(qm.show(question: question3)).to eq(:to_complete)
      end

      it "shows mouse_translation view" do
        expect(qm.show(question: question4)).to eq(:mouse_translation)
      end
    end

    describe "#correctAnswer?" do

      it "multiple_choice return true if answer is true" do
        correct_answer = Answer.new(answer: "respuesta", correct: true, question: question1)
        expect(qm.correctAnswer?(answer: correct_answer, question: question1)).to be true
      end

      it "multiple_choice return false if answer is false" do
        incorrect_answer = Answer.new(answer: "respuesta", correct: false, question: question1)
        expect(qm.correctAnswer?(answer: incorrect_answer, question: question1)).to be false
      end

      it "translation return true if user_answer equals translation expected aswer" do
        correct_answer = Answer.create(answer: "respuesta", correct: true, question: question2)
        expect(qm.correctAnswer?(answer: correct_answer, question: question2)).to be true
        correct_answer.destroy
      end

      it "translation return false if user_answer not equals translation expected aswer" do
        correct_answer = Answer.create(answer: "respuesta", correct: true, question: question2)
        incorrect_answer = Answer.new(answer: "otra respuesta", correct: true, question: question2)
        expect(qm.correctAnswer?(answer: incorrect_answer, question: question2)).to be false
        correct_answer.destroy
      end

      it "to_complete return true if user_answer equals to_complete expected aswer" do
        correct_answer = Answer.create(answer: "respuesta", correct: true, question: question3)
        expect(qm.correctAnswer?(answer: correct_answer, question: question3)).to be true
        correct_answer.destroy
      end

      it "to_complete return false if user_answer not equals to_complete expected aswer" do
        correct_answer = Answer.create(answer: "respuesta", correct: true, question: question3)
        incorrect_answer = Answer.new(answer: "otra respuesta", correct: true, question: question3)
        expect(qm.correctAnswer?(answer: incorrect_answer, question: question3)).to be false
        correct_answer.destroy
      end

      it "mouse_translation return true if user_answer equals mouse_translation expected aswer" do
        correct_answer = Answer.create(answer: "respuesta", correct: true, question: question4)
        expect(qm.correctAnswer?(answer: correct_answer, question: question4)).to be true
        correct_answer.destroy
      end

      it "mouse_translation return false if user_answer not equals mouse_translation expected aswer" do
        correct_answer = Answer.create(answer: "respuesta", correct: true, question: question4)
        incorrect_answer = Answer.new(answer: "otra respuesta", correct: true, question: question4)
        expect(qm.correctAnswer?(answer: incorrect_answer, question: question4)).to be false
        correct_answer.destroy
      end

      it "Other questionable_type" do
        question = Question.create(questionable_type: "Hola", level: level)
        correct_answer = Answer.new(answer: "respuesta", correct: true, question: question)
        expect(qm.correctAnswer?(answer: correct_answer, question: question)).to be nil
        correct_answer.destroy
        question.destroy
      end
    end

    describe "#nextQuestion" do
      it "return next question of a question" do
        expect(qm.nextQuestion(question: question2)).to be question3
      end
    end

    describe '#buildUserAnswer' do
      it 'crea una nueva respuesta de usuario' do
        user_answer = qm.buildUserAnswer(answer: "respuesta del usuario", question: question1)
        expect(user_answer.answer).to eq("respuesta del usuario")
        expect(user_answer.correct).to be false
        expect(user_answer.question).to eq(question1)
        user_answer.destroy
      end
    end
  end
end
