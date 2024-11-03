# frozen_string_literal: true

require './models/level'
require './models/question'
# Este controlador se encarga de manejar los eventos relacionados a la lista de preguntas
# que fueron respondidas de forma correcta mas veces.
class CorrectlyAnsweredQuestionsController < Sinatra::Base
  set :views, File.expand_path('../views', __dir__)
  get '/admin/preguntasCorrectas' do
    if session[:admin_id]
      @levels = Level.where.not(playable_type: 'Tutorial')
      @questions = Question.where(level: @levels)
      erb :correctly_answered_questions
    else
      redirect '/login'
    end
  end
end
