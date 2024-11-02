# frozen_string_literal: true

require './models/user'
require './models/player'

# Esta clase se encarga de manejar la vista del perfil del jugador
class ProfileController < Sinatra::Base
  set :views, File.expand_path('../views', __dir__)

  def initialize(app = nil)
    super
    @gm = GameDataManager.new
    @qm = QuestionsManager.new
    @lm = LevelManager.new
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
end
