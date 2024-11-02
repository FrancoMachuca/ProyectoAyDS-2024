# frozen_string_literal: true

require 'sinatra/flash'
require './models/level'
require './controllers/levels_manager'
require './controllers/questions_manager'
# Controlador que maneja los eventos relacionados al formulario de creación de nuevas preguntas y niveles.
class QuestionLevelUploadController < Sinatra::Base
  set :views, File.expand_path('../views', __dir__)
  register Sinatra::Flash

  def initialize(app = nil)
    super
    @lm = LevelManager.new
    @qm = QuestionsManager.new
  end
  get '/admin/nivelesPreguntas' do
    if session[:admin_id]
      @levels = Level.where.not(playable_type: 'Tutorial')
      @level_type_values = Level.playable_types.without('Tutorial')
      @level_type_names = %w[Lección Examen]
      @level_types = @level_type_names.zip(@level_type_values)

      @questions = Question.where(level: @levels)
      @question_type_values = Question.questionable_types
      @question_type_names =  ['Multiple Opción', 'Completar la Palabra', 'Traducción', 'Pulsaciones',
                               'Lluvia Simbólica']
      @question_types = @question_type_names.zip(@question_type_values)
      @mc_answers = 4
      erb :questions_and_levels_upload
    else
      redirect '/login'
    end
  end

  post '/admin/nivelesPreguntas' do # rubocop:disable Metrics/BlockLength
    if session[:admin_id]
      @question_type = params[:question_type]
      @question_description = params[:question_description]
      @correct_answer = params[:correct_answer].without('').first
      @key_word = params[:key_word]
      @key_word_morse = params[:key_word_morse]
      @translation_type = params[:translation_type]
      @options = []
      %w[first second third fourth].each_with_index do |position, index|
        text = params["op#{index + 1}"]
        correct = !params["correct_option_#{position}"].nil?

        @options << { text: text, correct: correct }
        puts @options
      end
      puts params.inspect
      if params[:levels] == 'new'
        @level_type = params[:level_type]
        @level_name = params[:level_name]
        @min_score = params[:min_score]
        @lm.create_new_level(type: @level_type, name: @level_name, min_score: @min_score)
        @level = Level.last
      else
        @level = Level.find_by(id: params[:levels])
      end
      if @qm.validate_params(options: @options, correct_answer: @correct_answer,
                             question_description: @question_description, level: @level, question_type: @question_type,
                             translation_type: @translation_type, key_word: @key_word, key_word_morse: @key_word_morse)
        if @qm.create_new_question(question_type: @question_type, options: @options,
                                   translation_type: @translation_type, key_word: @key_word,
                                   key_word_morse: @key_word_morse,
                                   correct_answer: @correct_answer, question_description: @question_description,
                                   level: @level)
          flash[:success] = 'Pregunta y/o nivel creados correctamente.'
        else
          flash[:alert] = 'Se ha producido un error al crear la pregunta y/o nivel. Intentalo de nuevo.'
          Level.destroy(@level.id) if params[:levels] == 'new'
        end
      else
        Level.destroy(@level.id) if params[:levels] == 'new'
        flash[:alert] =
          'Se ha producido un error de validación. Verifica la información de la pregunta introducida'
      end
      redirect '/admin/nivelesPreguntas'
    else
      redirect '/login'
    end
  end
end
