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

    get '/' do
        redirect '/login'
    end
    
    get '/login' do
        File.read('login.html')
    end
    
    get '/registro' do
        File.read('registro.html')

    end
    post '/registro' do
        user = User.new(params[:user][:password])
        user2 = User.find_by(email: params[:user][:email])
        if user==user2
            redirect '/login'
        else
            user.save
            redirect '/login'
        end
    end
    post '/login' do
        user = User.find_by(email: params[:user][:email])
        if user && user.password == params[:user][:password]
            session[:user_id] = user.id
            redirect '/home'
        else
            redirect '/login'
        end
    end 

end

