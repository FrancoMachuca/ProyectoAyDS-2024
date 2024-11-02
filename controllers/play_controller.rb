require 'sinatra/base'
require 'sinatra/activerecord'
require './models/player'
require './models/user'
require './models/level'
require './models/lesson'
require './models/exam'
require './models/question'
require './models/multiple_choice'
require './models/translation'
require './models/mouse_translation'
require './models/answer'
require './models/player_level'
require './models/to_complete'
require './controllers/game_data_manager'
require './controllers/questions_manager'
# Clase que se encarga de manejar los eventos relacionados al juego.
class PlayController < Sinatra::Base
  set :views, File.expand_path('../views', __dir__)

  def initialize(app = nil)
    super
    @gm = GameDataManager.new
    @qm = QuestionsManager.new
    @lm = LevelManager.new
  end

  get '/jugar' do
    if session[:user_id]
      @player = Player.find(session[:player_id])
      @levels = Level.all.order(:id)
      @levels_unlocked = @player.levels
      erb :jugar
    else
      redirect '/login'
    end
  end

  get '/level/:level_id' do
    if session[:user_id]
      @player = Player.find(session[:player_id])
      @level = Level.find(params[:level_id])
      if @gm.unlocked_level?(player: @player, level: @level)
        session[:user_level_score] = 0
        if @gm.completed_level?(player: @player, level: @level)
          @gm.reset_player_level_score(player: @player, level: @level)
        end
        @questions = Question.where(level_id: params[:level_id])
        redirect "/level/#{params[:level_id]}/#{@questions.first.id}"
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
          erb @qm.show(question: @question) if @level && @question && @answers
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
      @player = Player.find_by(id: session[:player_id])
      if @question && @level
        @answers = Answer.where(question_id: @question.id)
        if @question.questionable_type == 'Translation' || @question.questionable_type == 'ToComplete' ||
           @question.questionable_type == 'MouseTranslation' || @question.questionable_type == 'FallingObject'
          @player_answer = @qm.build_player_answer(answer: params[:user_guess], question: @question)
        else
          @player_answer = Answer.find_by(id: params[:answer_id])
        end
        if @qm.correct_answer?(answer: @player_answer, question: @question)
          session[:user_level_score] += 100
          @question.update(times_answered_correctly: (@question.times_answered_correctly + 1))
        else
          @question.update(times_answered_incorrectly: (@question.times_answered_incorrectly + 1))
        end

        @next_question = @qm.next_question(question: @question)
        if @next_question
          redirect "/level/#{params[:level_id]}/" + @next_question.id.to_s
        else
          @player = Player.find_by(id: session[:player_id])
          @gm.add_player_level_score(player: @player, level: @level, value: session[:user_level_score])
          @final_score = session[:user_level_score]
          session[:user_level_score] = 0
          if @gm.completed_level?(level: @level, player: @player)
            @show_success_popup = true
          else
            @show_failure_popup = true
          end
          @gm.unlock_next_level_for(player: @player, possibly_completed: @level)
          erb @qm.show(question: @question)
        end
      else
        redirect '/jugar'
      end
    else
      redirect '/login'
    end
  end
end
