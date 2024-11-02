# frozen_string_literal: true

# Controlador que se encarga de manejar los eventos relacionados al inicio y cierre de sesión.
class LoginController < Sinatra::Base
  set :views, File.expand_path('../views', __dir__)
  get '/login' do
    erb :login
  end

  post '/login' do
    user = User.find_by(name: params[:name], password: params[:password])
    if user
      session[:user_id] = user.id
      if user.userable_type == 'Player'
        session[:player_id] = user.player_id
        redirect '/jugar'
      else
        session[:admin_id] = user.admin.id

        redirect '/admin'
      end

    else
      @error_message = 'Nombre de usuario o contraseña son incorrectas'
      erb :login
    end
  end

  get '/logout' do
    session.clear
    redirect '/login'
  end
end
