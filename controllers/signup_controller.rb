# frozen_string_literal: true

require './controllers/game_data_manager'
# Controlador encargado de manejar los eventos relacionados al registro de nuevos usuarios.
class SignupController < Sinatra::Base
  @gm = GameDataManager.new
  set :views, File.expand_path('../views', __dir__)
  get '/registro' do
    erb :registro
  end

  post '/registro' do
    user = User.find_by(mail: params[:mail]) || User.find_by(name: params[:name])
    if user
      @error_message = 'Usted ya tenía una cuenta previa'
      erb :login
    else
      image = Image.first
      user = User.new(name: params[:name], mail: params[:mail], password: params[:password],
                      image: image, userable: Player.create!)
      if user.save
        @gm.create_game_data_for(player: user.player)
        session[:player_id] = user.player_id
        session[:user_id] = user.id
        redirect '/login'
      end
    end
  end
end
