require 'sinatra/base'
require 'sinatra/activerecord'
require_relative './models/user'
require './models/level'
require './models/lesson'
require './models/exam'
require './models/question'




class MyApp < Sinatra::Application
    def initialize(myapp = nil)
        super()
    end
    set :database_file, './config/database.yml'
    enable :sessions

    get '/' do
        redirect '/login'
    end
    
    get '/login' do
        erb :login
    end

    post '/login' do
        user = User.find_by(name: params[:name], password: params[:password])
        if user
            session[:user_id] = user.id
            redirect '/menu'
        else
            @error_message = "Nombre de usuario o contraseña son incorrectas"
            erb :login
        end
    end 
    
    get '/registro' do
        erb :registro
    end
    
    post '/registro' do
        user = User.find_by(mail: params[:mail]) || User.find_by(name: params[:name])
        if user
            @error_message = "Usted ya tenia una cuenta previa"
            erb :login
        else
            user = User.new(name: params[:name], mail: params[:mail],password: params[:password], totalScore: 0)
            if user.save
                session[:user_id] = user.id
                redirect '/login'
            else
                @error_message = "Error al crear cuenta"
                erb :registro
            end
        end
    end
    
    get '/logout' do
        session.clear
        redirect '/'
    end


end

