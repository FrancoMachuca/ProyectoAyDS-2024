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
require_relative 'controllers/image_controller'
require_relative 'controllers/login_controller'
require_relative 'controllers/signup_controller'
require_relative 'controllers/question_level_upload_controller'
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
  use ImageController
  use QuestionLevelUploadController
  get '/' do
    redirect '/jugar' if session[:player_id]
    redirect '/admin' if session[:admin_id]
    redirect '/login'
  end

  get '/perfil' do
    if session[:user_id]
      @user = User.find(session[:user_id])
      @player = Player.find(session[:player_id])
      @total_score = @gm.get_total_score_of(player: @player)
      @levels_completed = @gm.get_amount_of_levels_completed(player: @player)
      @rank = @gm.get_player_rank(player: @player)
      erb :profile
    else
      redirect '/login'
    end
  end

  get '/ranking' do
    if session[:user_id]
      @players = Player.all
      erb :ranking
    else
      redirect '/login'
    end
  end

  get '/admin' do
    erb :admin_menu
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
