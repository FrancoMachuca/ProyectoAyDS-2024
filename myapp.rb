require 'sinatra/base'
require 'sinatra/activerecord'
require './models/user'
require './models/level'
require './models/lesson'
require './models/exam'
require './models/question'
require './models/multiple_choice'
require './models/answer'
require './models/ranking'

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
    get '/level/:level_id' do
        @questions = Question.where(level_id: params[:level_id])
        redirect '/level/' + params[:level_id].to_s + '/' + @questions.first.id.to_s
    end

    get '/level/:level_id/:question_id' do
        if session[:user_id]
          @level = Level.find(params[:level_id])
          @questions = Question.where(level_id: params[:level_id])
          @answers = Answer.where(question_id: params[:question_id])
            erb :multiple_choice
        else
          redirect '/login'
        end
      end

      post '/level/:level_id/:question_id/check' do
        #Conflicto con el boton que redirecciona a acá cuando esta en la ultima pregunta. (questions se vuelve a llenar y no sale nunca)
        if session[:user_id]
          answer = Answer.find(params[:answer_id])
          @question = Question.find(params[:question_id])
          @level = Level.find(params[:level_id])
          @questions = Question.where(level_id: @level.id)
          puts @questions
          #@next_question = @questions.where("id > ?", @question.id).first
            

          if answer.correct
            user = User.find(session[:user_id])
            user.totalScore += 1
            user.save
            if !@questions.empty?
                @questions = @questions.drop(1)
                @answers = Answer.where(question_id: @questions.first.id)
                erb :multiple_choice
            else
                redirect "/jugar"
            end
          else
            if !@questions.empty?
                @questions = @questions.drop(1)
                @answers = Answer.where(question_id: @questions.first.id)
                erb :multiple_choice
            else
                redirect "/jugar"
            end
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

    post '/question/:id/submit_answer' do
        @user = User.find_by(username: session[:username]) 
      
        answer_id = params[:answer].id
        answer = Answer.find(answer_id)
        question_id = answer.question.id
        @question = Question.find(question_id)
        session[:success] = nil
        session[:error] = nil
        
        if answer.correct
          # Respuesta correcta
          session[:answered_questions] << question_id
          session[:success] = 'correct_answer'
          redirect "/level/#{params[:id]}/"
        else
            session[:error] = 'wrong_answer'
            redirect "/question/#{params[:id]}"
        end
    end
end
end
    
end