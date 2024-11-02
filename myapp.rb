# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require './models/admin'
require './models/player'
require './models/user'
require './models/level'
require './models/lesson'
require './models/exam'
require './models/question'
require './models/multiple_choice'
require './models/translation'
require './models/mouse_translation'
require './models/answer'
require './models/player_level'
require './models/to_complete'
require './models/image'
require './controllers/game_data_manager'
require './controllers/questions_manager'
require './controllers/levels_manager'
require './controllers/play_controller'
require './uploader/image_uploader'
require './controllers/login_controller'
require './controllers/signup_controller'
require './controllers/image_controller'
require './controllers/profile_controller'
require './controllers/ranking_controller'
require './controllers/level_controller'
# Server
class MyApp < Sinatra::Application
  # Configuración de Carrierwave
  CarrierWave.configure do |config|
    config.root = "#{File.dirname(__FILE__)}/public"
  end

  def initialize(_myapp = nil)
    super()
    @gm = GameDataManager.new
    @qm = QuestionsManager.new
    @lm = LevelManager.new
  end

  set :public_folder, 'public'
  set :database_file, './config/database.yml'
  enable :sessions
  use LoginController
  use SignupController
  use PlayController
  use LevelController
  use ImageController
  use ProfileController
  use RankingController

  get '/' do
    redirect '/jugar' if session[:player_id]
    redirect '/admin' if session[:admin_id]
    redirect '/login'
  end

  get '/admin' do
    erb :admin_menu
  end

  get '/admin/nivelesPreguntas' do
    if session[:admin_id]
      @levels = Level.where.not(playable_type: 'Tutorial')
      @level_type_values = Level.playable_types
      @level_type_names = %w[Lección Examen Tutorial]
      @level_types = @level_type_names.zip(@level_type_values)

      @questions = Question.where(level: @levels)
      @question_type_values = Question.questionable_types
      @question_type_names =  ['Multiple Opción', 'Completar la Palabra', 'Traducción', 'Pulsaciones',
                               'Lluvia Simbólica']
      @question_types = @question_type_names.zip(@question_type_values)
      @mc_answers = 4
      erb :questions_and_levels_upload
    else
      redirect '/login'
    end
  end

  post '/admin/nivelesPreguntas' do
    if session[:admin_id]
      @question_type = params[:question_type]
      @question_description = params[:question_description]
      @correct_answer = params[:correct_answer].compact.first
      @key_word = params[:key_word]
      @key_word_morse = params[:key_word_morse]
      @translation_type = params[:translation_type]
      @options = []
      %w[first second third fourth].each_with_index do |position, index|
        text = params["op#{index + 1}"]
        correct = params["correct_answer_#{position}"] == 'true'

        @options << { text: text, correct: correct }
      end
      puts params.inspect
      if params[:levels] == 'new'
        @level_type = params[:level_type]
        @level_name = params[:level_name]
        @min_score = params[:min_score]
        @lm.create_new_level(type: @level_type, name: @level_name, min_score: @min_score)
        @level = Level.last
      else
        @level = Level.find_by(id: params[:levels])
      end
      if @qm.validate_params(question_type: @question_type, options: @options,
                             translation_type: @translation_type, key_word: @key_word, key_word_morse: @key_word_morse, correct_answer: @correct_answer, question_description: @question_description, level: @level)
        if @qm.create_new_question(question_type: @question_type, options: @options,
                                   translation_type: @translation_type, key_word: @key_word, key_word_morse: @key_word_morse, correct_answer: @correct_answer, question_description: @question_description, level: @level)
          flash[:success] = 'Pregunta y/o nivel creados correctamente.'
        else
          flash[:alert] = 'Se ha producido un error al crear la pregunta y/o nivel. Intentalo de nuevo.'
        end
      else
        @level.destroy if params[:levels] == 'new'
        flash[:alert] =
          'Se ha producido un error de validación. Verifica la información de la pregunta introducida'
      end
      redirect '/admin/nivelesPreguntas'
    else
      redirect '/login'
    end
  end

  get '/admin/preguntasCorrectas' do
    if session[:admin_id]
      @levels = Level.where.not(playable_type: 'Tutorial')
      @questions = Question.where(level: @levels)
      erb :correctly_answered_questions
    else
      redirect '/login'
    end
  end

  get '/admin/preguntasIncorrectas' do
    if session[:admin_id]
      @levels = Level.where.not(playable_type: 'Tutorial')
      @questions = Question.where(level: @levels)
      erb :incorrectly_answered_questions
    else
      redirect '/login'
    end
  end
end
