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
        @users = User.all
        erb :prueba
    end
    
    post '/login/post' do
    
    
    end 
    
end

