require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
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
require './models/image'
require './controllers/game_data_manager'
require './controllers/questions_manager'
require './controllers/levels_manager'
require './uploader/image_uploader'

class MyApp < Sinatra::Application
    #Configuración de Carrierwave
    CarrierWave.configure do |config|
        config.root = File.dirname(__FILE__) + "/public"
    end

    def initialize(myapp = nil)
        super()
        @gm = GameDataManager.new
        @qm = QuestionsManager.new
        @lm = LevelManager.new
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
            if user.userable_type == 'Player'
                session[:player_id] = user.player_id
                redirect '/jugar'
            else
                session[:admin_id] = user.admin.id

                redirect '/admin'
            end

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
            image = Image.first
            user = User.new(name: params[:name], mail: params[:mail], password: params[:password], image: image)
            if user.save
                @gm.createGameDataFor(user: user)
                session[:user_id] = user.id
                redirect '/login'
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

    get '/actualizarFoto' do
        if session[:user_id]
            erb :upload_image
        else
            redirect '/login'
        end
    end

    post "/actualizarFoto" do
        if session[:user_id]
            defaultPic = Image.first
            img = Image.new
            user = User.find(session[:user_id])
            img.image = params[:file] #carrierwave sube el archivo automáticamente.
            img.caption = "Profile Pic" #Se puede recibir otro con params.
            if !img.nil? && !img.image.nil? && img.valid? #Se pueden agregar más restricciones
                begin
                    if !user.image.nil?
                        i = user.image
                        user.image = nil
                        user.save!
                    end
                    user.image = img
                    img.save!
                    user.save!
                    if !i.nil? && i.users.empty? && i != defaultPic
                        i.remove_image!  
                        Image.delete(i)
                    end
                rescue => error # Si la imagen nueva no se guarda correctamente, o si la anterior no se borra de la base de datos, se restaura la anterior.
                        user.image = i
                        user.save
                        puts error.message
                end
            end
        end
        redirect '/perfil'
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
            @user = User.find(session[:user_id])
            @level = Level.find(params[:level_id])
            if @gm.unlockedLevel?(user: @user, level: @level)
                session[:user_level_score] = 0
                if @gm.completedLevel?(user: @user, level: @level)
                    @gm.resetUserLevelScore(user: @user, level: @level)
                end
                @questions = Question.where(level_id: params[:level_id])
                redirect '/level/' + params[:level_id].to_s + '/' + @questions.first.id.to_s
            else
                redirect '/jugar'
            end
        else
            redirect '/login'
        end
    end

    get '/level/:level_id/:question_id' do
        if session[:user_id]
            if Level.exists?(params[:level_id])
                @level = Level.find(params[:level_id])
                if @level.questions.exists?(params[:question_id])
                    @question = Question.find(params[:question_id])
                    @answers = Answer.where(question_id: @question.id)
                    if @level && @question && @answers
                      erb @qm.show(question: @question)
                    end
                else
                    redirect '/jugar'
                end
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
            @user = User.find_by(id: session[:user_id])
            if @question && @level
                @answers = Answer.where(question_id: @question.id)
                if @question.questionable_type == "Translation" || @question.questionable_type == "To_complete" ||
                   @question.questionable_type == "MouseTranslation" || @question.questionable_type == "FallingObject"
                    @user_answer = @qm.buildUserAnswer(answer: params[:user_guess], question: @question)
                else
                    @user_answer = Answer.find_by(id: params[:answer_id])
                end
                if @qm.correctAnswer?(answer: @user_answer, question: @question)
                    session[:user_level_score] += 100
                    @question.update(times_answered_correctly: (@question.times_answered_correctly + 1))
                else
                    @question.update(times_answered_incorrectly: (@question.times_answered_incorrectly + 1))
                end

                @next_question = @qm.nextQuestion(question: @question)
                if @next_question
                    redirect "/level/#{params[:level_id]}/" + @next_question.id.to_s
                else
                    @player = Player.find_by(id: session[:player_id])
                    @gm.addPlayerLevelScore(player: @player, level: @level, value: session[:user_level_score])
                    @final_score = session[:user_level_score]
                    session[:user_level_score] = 0
                    if @gm.completedLevel?(level: @level, user: @user)
                        @show_success_popup = true
                    else
                        @show_failure_popup = true
                    end
                    @gm.unlockNextLevelFor(user: @user, possiblyCompleted: @level)
                    erb @qm.show(question: @question)
                end
            else
                redirect "/jugar"
            end
        else
            redirect "/login"
        end
    end

    get '/admin' do
        erb :admin_menu
    end

    get '/admin/nivelesPreguntas' do
        if session[:admin_id]
            @levels = Level.where.not(playable_type: "Tutorial")
            @level_type_values = Level.playable_types
            @level_type_names = ["Lección", "Examen", "Tutorial"]
            @level_types = @level_type_names.zip(@level_type_values)

            @questions = Question.where(level: @levels)
            @question_type_values = Question.questionable_types
            @question_type_names =  ["Multiple Opción", "Completar la Palabra", "Traducción", "Pulsaciones", "Lluvia Simbólica"]
            @question_types = @question_type_names.zip(@question_type_values)
            @mc_answers = 4
            erb :questions_and_levels_upload
        else
            redirect "/login"
        end
    end

    post '/admin/nivelesPreguntas' do
        if session[:admin_id]
            @question_type = params[:question_type]
            @question_description = params[:question_description]
            @correct_answer = params[:correct_answer].compact.first
            @key_word = params[:key_word]
            @key_word_morse = params[:key_word_morse]
            @translation_type = params[:translation_type]
            @options = []
            (1..4).each do |i|
                text = params["op#{i}"]
                correct = params["correct_option_#{i}"] == 'true'

                @options << { text: text, correct: correct }
            end
            puts params.inspect
            if params[:levels] == "new"
                @level_type = params[:level_type]
                @level_name = params[:level_name]
                @min_score = params[:min_score]
                @lm.createNewLevel(type: @level_type, name: @level_name, min_score: @min_score)
                @level = Level.last
            else
                @level = Level.find_by(id: params[:levels])
            end
            if @qm.validateParams(question_type: @question_type, options: @options, translation_type: @translation_type, key_word: @key_word, key_word_morse: @key_word_morse, correct_answer: @correct_answer, question_description: @question_description, level: @level)
                if @qm.createNewQuestion(question_type: @question_type, options: @options, translation_type: @translation_type, key_word: @key_word, key_word_morse: @key_word_morse, correct_answer: @correct_answer, question_description: @question_description, level: @level)
                    flash[:success] = "Pregunta y/o nivel creados correctamente."
                else
                    flash[:alert] = "Se ha producido un error al crear la pregunta y/o nivel. Intentalo de nuevo."
                end
            else
                if params[:levels] == "new"
                    @level.destroy
                end
                flash[:alert] = "Se ha producido un error de validación. Verifica la información de la pregunta introducida"
            end
            redirect '/admin/nivelesPreguntas'
        else
            redirect '/login'
        end
    end

    get '/admin/preguntasCorrectas' do
        if session[:admin_id]
            @levels = Level.where.not(playable_type: "Tutorial")
            @questions = Question.where(level: @levels)
            erb :correctly_answered_questions
        else
            redirect "/login"
        end
    end

    get '/admin/preguntasIncorrectas' do
        if session[:admin_id]
            @levels = Level.where.not(playable_type: "Tutorial")
            @questions = Question.where(level: @levels)
            erb :incorrectly_answered_questions
        else
            redirect "/login"
        end
    end
end
