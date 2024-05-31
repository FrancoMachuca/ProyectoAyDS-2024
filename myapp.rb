require 'sinatra/base'
require 'sinatra/activerecord'
require_relative './models/user'
require './models/level'
require './models/lesson'
require './models/exam'
require './models/question'
require './models/user_level'
require './models/multiple_choice'
require './models/multiple_choice_answer'
require './models/answer'

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
            redirect '/jugar'
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
            @error_message = "Usted ya tenía una cuenta previa"
            erb :login
        else
            user = User.new(name: params[:name], mail: params[:mail], password: params[:password], totalScore: 0)
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

    get '/perfil' do
        if session[:user_id]
            @user = User.find(session[:user_id])
            erb :profile
        else
            redirect '/login'
        end
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
            @levels = Level.all.order(:id)
            erb :jugar
        else
            redirect '/login'
        end
    end

    get '/ranking' do
        if session[:user_id]
            @users = User.order(totalScore: :desc)
            erb :ranking
        else
            redirect '/login'
        end
    end

    get '/level/:id' do
        if session[:user_id]
          @level = Level.find(params[:id])
          @questions = Question.where(level_id: params[:id]).limit(2)
          @answers = Answer.where(question_id: params[:id])
          erb :multiple_choice
        else
          redirect '/login'
        end
      end

      post '/level/:id/check' do
        if session[:user_id]
          answer = Answer.find(params[:answer_id])
          @question = Question.find(params[:question_id])
          @level = Level.find(params[:id])
          @questions = Question.where(level_id: @level.id)
          @next_question = @questions.where("id > ?", @question.id).first

          if answer.correct
            user = User.find(session[:user_id])
            user.totalScore += 1
            user.save
          end

          if @next_question
            @answers = Answer.where(question_id: @next_question.id)
            erb :multiple_choice
          else
            "¡Has completado el nivel!"
          end
        else
          redirect '/login'
        end
      end

      get '/level/:id/question/:question_id' do
        if session[:user_id]
          @level = Level.find(params[:id])
          @question = Question.find(params[:question_id])
          @answers = Answer.where(question_id: @question.id)
          erb :multiple_choice
        else
          redirect '/login'
        end
      end

    get '/question/:id' do
        if session[:user_id]
            @question = Question.find(params[:id])
            case @question
            when MultipleChoice
                @answers = @question.multiple_choice_answers
                erb :multiple_choice
            else
                erb :unknown_question_type
            end
        else
            redirect '/login'
        end
    end

    post '/question/:id/check' do
        if session[:user_id]
            @question = Question.find(params[:id])
            correct = false

            case @question
            when MultipleChoice
                answer = MultipleChoiceAnswer.find(params[:answer_id])
                correct = answer.correct
            end

            if correct
                # Lógica para cuando la respuesta es correcta
                redirect "/level/#{@question.level_id}", notice: '¡Correcto!'
            else
                # Lógica para cuando la respuesta es incorrecta
                redirect "/question/#{@question.id}", alert: 'Respuesta incorrecta. Inténtalo de nuevo.'
            end
        else
            redirect '/login'
        end
    end
end
