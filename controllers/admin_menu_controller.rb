# frozen_string_literal: true

# Este controlador se encarga de manejar los eventos relacionados al menú del administrador.
class AdminMenuController < Sinatra::Base
  set :views, File.expand_path('../views', __dir__)
  get '/admin' do
    erb :admin_menu
  end
end
