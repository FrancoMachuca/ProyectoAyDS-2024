require 'sinatra/base'
require 'sinatra/activerecord'
require_relative './models/user'
require './models/level'
require './models/lesson'
require './models/exam'
require './models/question'
require './models/user_level'




class MyApp < Sinatra::Application
    def initialize(myapp = nil)
        super()
    end
    set :database_file, './config/database.yml'
    enable :sessions

    get '/' do
        redirect '/login'
    end

    get '/usuarios' do
        @users = User.all
        erb :prueba
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

    get '/menu' do
        if session[:user_id]
            @user = User.find(session[:user_id])
            erb :menu
        else
            redirect '/login'
        end
    end

    get '/jugar' do
        if session[:user_id]
            @user = User.find(session[:user_id])
            @levels = Level.order(:id)
            erb :jugar
        else
            redirect '/login'
        end
    end

    post '/completar_nivel' do
        if session[:user_id]
            user = User.find(session[:user_id])
            level = Level.find(params[:level_id])
            user.levels << level unless user.levels.include?(level)
            redirect '/jugar'
        else
            redirect '/login'
        end
    end

end
