# frozen_string_literal: true

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
require './controllers/game_data_manager'
require './controllers/questions_manager'

# Esta clase es el controlador del ranking,
# por lo que se encarga de manejar todas las variables utilizadas en la vista
class RankingController < Sinatra::Base
  set :views, File.expand_path('../views', __dir__)

  def initialize(app = nil)
    super
    @gm = GameDataManager.new
    @qm = QuestionsManager.new
    @lm = LevelManager.new
  end

  get '/ranking' do
    if session[:user_id]
      @players = Player.all
      erb :ranking
    else
      redirect '/login'
    end
  end
end
