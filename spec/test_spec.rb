ENV['APP_ENV'] = 'test'

require_relative '../myapp.rb'
require 'rspec'
require 'rack/test'
require './models/level'
require './models/tutorial'

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

    it "redirects to login page when trying to access number of correct answer menu" do
      get '/admin/preguntasCorrectas'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it "redirects to login page when trying to access number of incorrect answer menu" do
      get '/admin/preguntasIncorrectas'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it "redirects to login page when trying to access upload level and questions menu" do
      get '/admin/nivelesPreguntas'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it "redirects to login page when trying to create a level or question" do
      post '/admin/nivelesPreguntas'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it "shows an error message if log in credentials are incorrect" do
      post '/login', name: 'Homero Simpson', password: 'callefalsa123'
      expect(last_response.body).to include("Nombre de usuario o contraseña son incorrectas")
    end
  end

  context "when admin logged in" do
    before(:each) do
      get '/logout'
      post 'login', name: 'Franco Machuca', password: 'bokita'
    end

    it "shows the admin menu" do
      get '/admin'
      expect(last_response).to be_ok
      expect(last_request.path).to eq("/admin")
    end

    it "shows the ranking of correctly answered questions menu" do
      get '/admin/preguntasCorrectas'
      expect(last_response).to be_ok
      expect(last_request.path).to eq('/admin/preguntasCorrectas')
    end

    it "shows the ranking of incorrectly answered questions menu" do
      get '/admin/preguntasIncorrectas'
      expect(last_response).to be_ok
      expect(last_request.path).to eq('/admin/preguntasIncorrectas')
    end

    it "shows the upload level and questions menu" do
      get '/admin/nivelesPreguntas'
      expect(last_response).to be_ok
      expect(last_request.path).to eq('/admin/nivelesPreguntas')
    end

    it "allows an admin to create a new lesson" do
      post '/admin/nivelesPreguntas', {
        levels: 'new',
        level_type: 'Lesson',
        level_name: 'Nuevo Nivel',
        min_score: 1000,
        correct_answer: []
      }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/admin/nivelesPreguntas')
    end

    it "allows an admin to create a new tutorial" do
      post '/admin/nivelesPreguntas', {
        levels: 'new',
        level_type: 'Tutorial',
        level_name: 'Nuevo Nivel',
        min_score: 1000,
        correct_answer: []
      }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/admin/nivelesPreguntas')
    end

    it "allows an admin to create a new exam" do
      post '/admin/nivelesPreguntas', {
        levels: 'new',
        level_type: 'Exam',
        level_name: 'Nuevo Nivel',
        min_score: 1000,
        correct_answer: []
      }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/admin/nivelesPreguntas')
    end

    it "creates a new question with multiple_choice type" do
      post '/admin/nivelesPreguntas', {
        levels: '1',
        question_type: 'Multiple_choice',
        question_description: 'Pregunta de prueba',
        correct_option_1: 'true',
        correct_option_2: 'false',
        correct_option_3: 'false',
        correct_option_4: 'false',
        op1: 'Opción 1',
        op2: 'Opción 2',
        op3: 'Opción 3',
        op4: 'Opción 4',
        correct_answer: []
      }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/admin/nivelesPreguntas')
    end

    it "creates a new question with translation type (morse_translation)" do
      post '/admin/nivelesPreguntas', {
        levels: '1',
        question_type: 'Translation',
        translation_type: 'morse_translation',
        question_description: '.- Pregunta Morse',
        correct_answer: ['respuesta']
      }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/admin/nivelesPreguntas')
    end

    it "creates a new question with translation type (spanish_translation)" do
      post '/admin/nivelesPreguntas', {
        levels: '1',
        question_type: 'Translation',
        translation_type: 'spanish_translation',
        question_description: 'Test',
        correct_answer: ['.-']
      }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/admin/nivelesPreguntas')
    end

    it "creates a new question with translation type (none)" do
      post '/admin/nivelesPreguntas', {
        levels: '1',
        question_type: 'Translation',
        translation_type: 'Test',
        question_description: 'Test',
        correct_answer: ['.-']
      }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/admin/nivelesPreguntas')
    end

    it "creates a new question with to_complete type" do
      post '/admin/nivelesPreguntas', {
        levels: '1',
        question_type: 'To_complete',
        question_description: '.- Pregunta Morse',
        key_word: 'TEST',
        key_word_morse: '---...',
        correct_answer: ['---']
      }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/admin/nivelesPreguntas')
    end

    it "creates a new question with MouseTranslation type" do
      post '/admin/nivelesPreguntas', {
        levels: '1',
        question_type: 'MouseTranslation',
        question_description: 'Test',
        correct_answer: ['---']
      }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/admin/nivelesPreguntas')
    end

    it "creates a new question with FallingObject type" do
      post '/admin/nivelesPreguntas', {
        levels: '1',
        question_type: 'FallingObject',
        question_description: 'Test',
        correct_answer: ['---']
      }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/admin/nivelesPreguntas')
    end

    it "fails to create a question with invalid params" do
      post '/admin/nivelesPreguntas', {
        levels: '1',
        question_type: 'Multiple_choice',
        question_description: 'Pregunta de prueba',
        correct_option_1: 'false',
        correct_option_2: 'false',
        correct_option_3: 'false',
        correct_option_4: 'false',
        op1: 'Opción 1',
        op2: 'Opción 2',
        op3: 'Opción 3',
        op4: 'Opción 4',
        correct_answer: []
      }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/admin/nivelesPreguntas')
    end

    it "fails to create a question when passing an invalid level as an argument" do
      post '/admin/nivelesPreguntas', {
        levels: '100',
        question_type: 'Multiple_choice',
        question_description: 'Pregunta de prueba',
        correct_option_1: 'true',
        correct_option_2: 'false',
        correct_option_3: 'false',
        correct_option_4: 'false',
        op1: 'Opción 1',
        op2: 'Opción 2',
        op3: 'Opción 3',
        op4: 'Opción 4',
        correct_answer: []
      }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/admin/nivelesPreguntas')
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

    it "shows the photo update page" do
      get '/actualizarFoto'
      expect(last_response).to be_ok
    end

    it "doesn't allow to play locked levels" do
      get '/level/2'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq("/jugar")
    end
  end

  context "when playing" do
    before(:each) do
      get '/logout'
      u = User.new(name: 'Homero Simpson', password: 'callefalsa123', mail: 'hs@example.com', userable: Player.create!())
      u.save
      i = 1
      while i <= Level.all.size
        PlayerLevel.create(player: u.player, level: Level.find(i), playerLevelScore: 500)
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

    it "gets the amount of unlocked levels" do
      u = User.find_by(name: 'Homero Simpson')
      gm = GameDataManager.new
      amount = gm.getAmountOfLevelsCompleted(player: u.player)
      expect(amount).to eq(Level.all.size)
    end

    it "unlocks exams correctly" do
      u = User.find_by(name: 'Homero Simpson')
      PlayerLevel.destroy_by(player: u.player, level: Level.find(6), playerLevelScore: 500)
      gm = GameDataManager.new
      gm.unlockNextLevelFor(player: u.player, possiblyCompleted: Level.find(5))
      get '/level/6'
      follow_redirect!
      expect(last_request.path).to eq('/level/6/22')
    end

    it "unlocks levels correctly" do
      u = User.find_by(name: 'Homero Simpson')
      PlayerLevel.destroy_by(player: u.player, level: Level.find(6))
      PlayerLevel.destroy_by(player: u.player, level: Level.find(5))
      gm = GameDataManager.new
      gm.unlockNextLevelFor(player: u.player, possiblyCompleted: Level.find(4))
      get '/level/5'
      follow_redirect!
      expect(last_request.path).to eq('/level/5/18')
    end

    it "enters to an exam correctly" do
      get '/level/6'
      follow_redirect!
      expect(last_response).to be_ok
    end

    it "doesn't unlock a level without having beaten the previous one first" do
      u = User.find_by(name: 'Homero Simpson')
      PlayerLevel.destroy_by(player: u.player, level: Level.find(6))
      PlayerLevel.destroy_by(player: u.player, level: Level.find(5))
      gm = GameDataManager.new
      gm.unlockNextLevelFor(player: u.player, possiblyCompleted: Level.find(5))
      get '/level/6'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq("/jugar")
    end

    it "checks an answer correctly (User-input)" do
      get '/level/2'
      follow_redirect!
      post '/level/2/6/check', user_guess: 'a'
      follow_redirect!
      expect(last_request.path).to eq('/level/2/7')
    end

    it "checks an answer correctly (Multiple-choice)" do
      get '/level/2'
      follow_redirect!
      post '/level/2/7/check', answer_id: '2'
      follow_redirect!
      expect(last_request.path).to eq('/level/2/8')
    end
    it "redirects to the level selection page when trying to access an invalid question" do
      get '/level/2/21'
      follow_redirect!
      expect(last_request.path).to eq('/jugar')
    end

    it "redirects to the level selection page when trying to access an invalid level" do
      get '/level/100/1'
      follow_redirect!
      expect(last_request.path).to eq('/jugar')
    end

    it "redirects to the level selection page when trying to answer an invalid question" do
      post '/level/2/5000/check', user_guess: 'a'
      follow_redirect!
      expect(last_request.path).to eq('/jugar')
    end

    it "redirects to the level selection page when trying to answer a question of an invalid level" do
      post '/level/100/1/check'
      follow_redirect!
      expect(last_request.path).to eq('/jugar')
    end

    it "shows the level success popup correctly" do
      get '/level/2'
      follow_redirect!
      post '/level/2/6/check', user_guess: 'a'
      follow_redirect!
      post '/level/2/7/check', answer_id: '1'
      follow_redirect!
      post '/level/2/8/check', user_guess: 'b'
      follow_redirect!
      post '/level/2/9/check', user_guess: '.-'
      expect(last_response).to be_ok
    end

    it "shows the level failed popup correctly" do
      get '/level/2'
      follow_redirect!
      post '/level/2/6/check', user_guess: 'abc'
      follow_redirect!
      post '/level/2/7/check', answer_id: '4'
      follow_redirect!
      post '/level/2/8/check', user_guess: 'bca'
      follow_redirect!
      post '/level/2/9/check', user_guess: '.'
      expect(last_response).to be_ok
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
      User.create(name: 'Homero Simpson', password: 'callefalsa123', mail: 'hs@example.com', userable: Player.create!())
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
    let(:question5) { Question.create(description: "prueba4", questionable_type: "FallingObject", level: level) }

    before do
      level.questions.push(question2)
      level.questions.push(question3)
      level.questions.push(question4)
      level.questions.push(question5)
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

      it "shows falling_object view" do
        expect(qm.show(question: question5)).to eq(:falling_object)
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

      it "translation return true if user_answer equals translation expected answer" do
        correct_answer = Answer.create(answer: "respuesta", correct: true, question: question2)
        expect(qm.correctAnswer?(answer: correct_answer, question: question2)).to be true
        correct_answer.destroy
      end

      it "translation return false if user_answer not equals translation expected answer" do
        correct_answer = Answer.create(answer: "respuesta", correct: true, question: question2)
        incorrect_answer = Answer.new(answer: "otra respuesta", correct: true, question: question2)
        expect(qm.correctAnswer?(answer: incorrect_answer, question: question2)).to be false
        correct_answer.destroy
      end

      it "to_complete return true if user_answer equals to_complete expected answer" do
        correct_answer = Answer.create(answer: "respuesta", correct: true, question: question3)
        expect(qm.correctAnswer?(answer: correct_answer, question: question3)).to be true
        correct_answer.destroy
      end

      it "to_complete return false if user_answer not equals to_complete expected answer" do
        correct_answer = Answer.create(answer: "respuesta", correct: true, question: question3)
        incorrect_answer = Answer.new(answer: "otra respuesta", correct: true, question: question3)
        expect(qm.correctAnswer?(answer: incorrect_answer, question: question3)).to be false
        correct_answer.destroy
      end

      it "mouse_translation return true if user_answer equals mouse_translation expected answer" do
        correct_answer = Answer.create(answer: "respuesta", correct: true, question: question4)
        expect(qm.correctAnswer?(answer: correct_answer, question: question4)).to be true
        correct_answer.destroy
      end

      it "mouse_translation return false if user_answer not equals mouse_translation expected answer" do
        correct_answer = Answer.create(answer: "respuesta", correct: true, question: question4)
        incorrect_answer = Answer.new(answer: "otra respuesta", correct: true, question: question4)
        expect(qm.correctAnswer?(answer: incorrect_answer, question: question4)).to be false
        correct_answer.destroy
      end

      it "falling_object return true if user_answer equals falling_object expected answer" do
        correct_answer = Answer.create(answer: "respuesta", correct: true, question: question5)
        expect(qm.correctAnswer?(answer: correct_answer, question: question5)).to be true
        correct_answer.destroy
      end

      it "falling_object return false if user_answer not equals falling_object expected answer" do
        correct_answer = Answer.create(answer: "respuesta", correct: true, question: question5)
        incorrect_answer = Answer.new(answer: "otra respuesta", correct: true, question: question5)
        expect(qm.correctAnswer?(answer: incorrect_answer, question: question5)).to be false
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
      it 'creates a new user answer' do
        user_answer = qm.buildPlayerAnswer(answer: "user answer", question: question1)
        expect(user_answer.answer).to eq("user answer")
        expect(user_answer.correct).to be false
        expect(user_answer.question).to eq(question1)
        user_answer.destroy
      end
    end
  end
end
