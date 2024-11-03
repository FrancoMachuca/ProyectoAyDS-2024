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
require_relative 'controllers/login_controller'
require_relative 'controllers/signup_controller'
require_relative 'controllers/question_level_upload_controller'
require_relative 'controllers/image_controller'
require_relative 'controllers/profile_controller'
require_relative 'controllers/ranking_controller'
require_relative 'controllers/level_controller'
require_relative 'controllers/admin_menu_controller'
require_relative 'controllers/correctly_answered_questions_controller'
require_relative 'controllers/incorrectly_answered_questions_controller'

# Server
class MyApp < Sinatra::Application
  # Configuración de Carrierwave
  CarrierWave.configure do |config|
    config.root = "#{File.dirname(__FILE__)}/public"
  end

  set :public_folder, 'public'
  set :database_file, './config/database.yml'
  enable :sessions
  use LoginController
  use SignupController
  use PlayController
  use LevelController
  use ImageController
  use QuestionLevelUploadController
  use ProfileController
  use RankingController
  use AdminMenuController
  use IncorrectlyAnsweredQuestionsController
  use CorrectlyAnsweredQuestionsController

  get '/' do
    redirect '/jugar' if session[:player_id]
    redirect '/admin' if session[:admin_id]
    redirect '/login'
  end
end
