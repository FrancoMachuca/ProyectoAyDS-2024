# frozen_string_literal: true

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

# Esta clase se encarga de controlar los endpoints de los niveles
# y los resultados de cada nivel jugado
class LevelController < Sinatra::Base
  set :views, File.expand_path('../views', __dir__)

  def initialize(app = nil)
    super
    @gm = GameDataManager.new
    @qm = QuestionsManager.new
    @lm = LevelManager.new
  end

  get '/level/:level_id' do
    redirect '/login' unless session[:user_id]

    @player = Player.find_by(id: session[:player_id])
    @level = Level.find_by(id: params[:level_id])

    if level_accessible?(@player, @level)
      setup_level_session(@player, @level)
      first_question = @level.questions.first
      redirect "/level/#{@level.id}/#{first_question.id}"
    else
      redirect '/jugar'
    end
  end

  def level_accessible?(player, level)
    level && @gm.unlocked_level?(player: player, level: level)
  end

  def setup_level_session(player, level)
    session[:user_level_score] = 0
    @gm.reset_player_level_score(player: player, level: level) if @gm.completed_level?(player: player, level: level)
  end

  def first_question_for_level(level)
    level.questions.first
  end

  get '/level/:level_id/:question_id' do
    redirect '/login' unless session[:user_id]

    @level = Level.find_by(id: params[:level_id])

    if @level
      @question = @level.questions.find_by(id: params[:question_id])

      if @question
        @answers = Answer.where(question_id: @question.id)
        erb @qm.show(question: @question)
      else
        redirect '/jugar'
      end
    else
      redirect '/jugar'
    end
  end

  post '/level/:level_id/:question_id/check' do
    redirect '/login' unless session[:user_id]

    @question = Question.find_by(id: params[:question_id])
    @level = Level.find_by(id: params[:level_id])
    @player = Player.find_by(id: session[:player_id])

    if @question && @level
      @answers = Answer.where(question_id: @question.id)
      @player_answer = build_player_answer(@question, params)
      process_answer(@player_answer, @question)

      @next_question = @qm.next_question(question: @question)
      if @next_question
        redirect_to_next_question(@next_question)
      else
        finalize_level
        erb @qm.show(question: @question)
      end
    else
      redirect '/jugar'
    end
  end

  private

  def build_player_answer(question, params)
    if %w[Translation ToComplete MouseTranslation FallingObject].include?(question.questionable_type)
      @qm.build_player_answer(answer: params[:user_guess], question: question)
    else
      Answer.find_by(id: params[:answer_id])
    end
  end

  def process_answer(player_answer, question)
    if @qm.correct_answer?(answer: player_answer, question: question)
      session[:user_level_score] += 100
      question.increment!(:times_answered_correctly)
    else
      question.increment!(:times_answered_incorrectly)
    end
  end

  def redirect_to_next_question(next_question)
    redirect "/level/#{params[:level_id]}/#{next_question.id}"
  end

  def finalize_level
    @gm.add_player_level_score(player: @player, level: @level, value: session[:user_level_score])
    @final_score = session[:user_level_score]
    session[:user_level_score] = 0
    @show_success_popup = @gm.completed_level?(level: @level, player: @player)
    @show_failure_popup = !@show_success_popup
    @gm.unlock_next_level_for(player: @player, possibly_completed: @level)
  end
end
