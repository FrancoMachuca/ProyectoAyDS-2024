require 'sinatra/base'
require 'sinatra/activerecord'
require './models/user'
require './models/level'
require './models/lesson'
require './models/exam'
require './models/question'
require './models/multiple_choice'
require './models/translation'
require './models/mouse_translation'
require './models/answer'
require './models/user_level'
require './models/to_complete'
require './controllers/game_data_manager'
require './controllers/questions_manager'

class MyApp < Sinatra::Application
    def initialize(myapp = nil)
        super()
        @gm = GameDataManager.new
        @qm = QuestionsManager.new
    end

    set :public_folder, 'public'
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
            user = User.new(name: params[:name], mail: params[:mail], password: params[:password])
            if user.save
                @gm.createGameDataFor(user: user)
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
        redirect '/login'
    end

    get '/perfil' do
        if session[:user_id]
            @user = User.find(session[:user_id])
            @total_score = @gm.getTotalScoreOf(user: @user)
            @levels_completed = @gm.getAmountOfLevelsCompleted(user: @user)
            @rank = @gm.getUserRank(user: @user)
            erb :profile
        else
            redirect '/login'
        end
    end

    get '/jugar' do
        if session[:user_id]
            @user = User.find(session[:user_id])
            @levels = Level.all.order(:id)
            @levels_unlocked = @user.levels
            erb :jugar
        else
            redirect '/login'
        end
    end

    get '/ranking' do
        if session[:user_id]
            @users = User.all
            erb :ranking
        else
            redirect '/login'
        end
    end

    get '/level/:level_id' do
        if session[:user_id]
            session[:user_level_score] = 0
            @user = User.find(session[:user_id])
            @level = Level.find(params[:level_id])
            if @gm.completedLevel?(user: @user, level: @level)
                @gm.resetUserLevelScore(user: @user, level: @level)
            end
            @questions = Question.where(level_id: params[:level_id])
            redirect '/level/' + params[:level_id].to_s + '/' + @questions.first.id.to_s
        else
            redirect '/login'
        end
    end

    get '/level/:level_id/:question_id' do
        if session[:user_id]
            @level = Level.find(params[:level_id])
            @question = Question.find(params[:question_id])
            @answers = Answer.where(question_id: @question.id)
            if @level && @question && @answers
               erb @qm.show(question: @question)
            else
                redirect '/jugar'
            end
        else
            redirect '/login'
        end
    end

    post '/level/:level_id/:question_id/check' do
        if session[:user_id]
            @question = Question.find_by(id: params[:question_id])
            @level = Level.find_by(id: params[:level_id])
            if @question && @level

                if @question.questionable_type == "Translation" || @question.questionable_type == "To_complete" ||
                   @question.questionable_type == "MouseTranslation"
                    @user_answer = @qm.buildUserAnswer(answer: params[:user_guess], question: @question)
                else
                    @user_answer = Answer.find_by(id: params[:answer_id])
                end
                if @qm.correctAnswer?(answer: @user_answer, question: @question)
                    session[:user_level_score] += 100
                end

                @next_question = @qm.nextQuestion(question: @question)
                if @next_question
                    redirect "/level/#{params[:level_id]}/" + @next_question.id.to_s
                else
                    if session[:user_level_score] >= 0
                        @user = User.find_by(id: session[:user_id])
                        @gm.addUserLevelScore(user: @user, level: @level, value: session[:user_level_score])
                        @gm.unlockNextLevelFor(user: @user, possiblyCompleted: @level)
                    end

                    session[:userLevelScore] = 0
                    # Se debería mostrar el popup
                    @show_success_popup = true
                    @answers = Answer.where(question_id: @question.id)
                    @final_score = @gm.getLevelScore(user: @user, level: @level)
                    erb @qm.show(question: @question)
                end
            else
                redirect "/jugar"
            end
        else
            redirect "/login"
        end
    end
end
