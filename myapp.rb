require 'sinatra/base'
require 'sinatra/activerecord'
require './models/user'
require './models/level'
require './models/lesson'
require './models/exam'
require './models/question'
require './models/multiple_choice'
require './models/translation'
require './models/answer'
require './models/user_level'
require './controllers/game_data_manager'

class MyApp < Sinatra::Application
    def initialize(myapp = nil)
        super()
        @gm = GameDataManager.new
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

    get '/jugar' do
        if session[:user_id]
            @user = User.find(session[:user_id])
            @levels = Level.all.order(:id)
            @gm = GameDataManager.new
            erb :jugar
        else
            redirect '/login'
        end
    end

    get '/ranking' do
        if session[:user_id]
            @ranking = Ranking.
            erb :ranking
        else
            redirect '/login'
        end
    end
    get '/level/:level_id' do
        @user = User.find(session[:user_id])
        @level = Level.find(params[:level_id])
        if @gm.completedLevel?(user: @user, level: @level)
            @gm.resetUserLevelScore(user: @user, level: @level)
        end
        @questions = Question.where(level_id: params[:level_id])
        redirect '/level/' + params[:level_id].to_s + '/' + @questions.first.id.to_s
    end

    get '/level/:level_id/:question_id' do
        if session[:user_id]
          @level = Level.find(params[:level_id])
          @question = Question.find(params[:question_id])
          case @question.questionable_type
          when 'Multiple_choice'
            @answers = Answer.where(question_id: @question.id)
            erb :multiple_choice
          when 'Translation'
            erb :translation
          else
            puts "No se reconoce tipo"
          end
        else
          redirect '/login'
        end
    end

      post '/level/:level_id/:question_id/check' do
        #Conflicto con el boton que redirecciona a acá cuando esta en la ultima pregunta. (questions se vuelve a llenar y no sale nunca)
        if session[:user_id]
          @question = Question.find(params[:question_id])
          @level = Level.find(params[:level_id])
          @questions = Question.where(level_id: @level.id)
          @next_question = @questions.where("id > ?", @question.id).first
          @user = User.find(session[:user_id])
          if @next_question != nil
            case @question.questionable_type
            when 'Multiple_choice'
                answer = Answer.find(params[:answer_id])
                if answer.correct
                    @gm.addUserLevelScore(user: @user, level: @level, value: 100)
                    redirect "/level/#{params[:level_id]}/" + @next_question.id.to_s
                  else
                    redirect "/level/#{params[:level_id]}/" + @next_question.id.to_s
                end
            when 'Translation'
                @user_translation = params[:user_translation].strip.downcase
                @correct_translation = @question.answer.answer.strip.downcase
                if @user_translation == @correct_translation
                    @gm.addUserLevelScore(user: @user, level: @level, value: 100)
                    redirect "/level/#{params[:level_id]}/" + @next_question.id.to_s
                else
                # Redirigir a la siguiente pregunta o la página de fallo sin actualizar el puntaje
                    redirect "/level/#{params[:level_id]}/" + @next_question.id.to_s
                end
            else
                puts "No se reconoce tipo"
            end
          else
            if @gm.completedLevel?(user: @user, level: @level)
                @gm.unlockNextLevelFor(user: @user)
                @final_score = @gm.getLevelScore(user: @user, level: @level)
                @show_success_popup = true
                redirect "/jugar"
            else
                redirect "/jugar"
            end
          end
        else
          redirect '/login'
        end
      end
end
