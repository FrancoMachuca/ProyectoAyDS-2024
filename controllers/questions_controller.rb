class QuestionsController < ApplicationController
  def show
    @question = Question.find(params[:id])

    case @question
    when MultipleChoice
      render 'multiple_choice'
    when Translation
      render 'translation'
    else
      render 'unknown_question_type'
    end
  end

  def check_answer
    @question = Question.find(params[:id])

    case @question
    when MultipleChoice
      # Lógica para comprobar la respuesta de MultipleChoice
      correct = MultipleChoiceAnswer.find(params[:answer_id]).correct?
    when Translation
      # Lógica para comprobar la respuesta de Translation
      correct = params[:translation].strip.downcase == @question.correct_answer.strip.downcase
    else
      correct = false
    end

    if correct
      # Lógica para cuando la respuesta es correcta
      redirect_to next_question_path, notice: '¡Correcto!'
    else
      # Lógica para cuando la respuesta es incorrecta
      redirect_to question_path(@question), alert: 'Respuesta incorrecta. Inténtalo de nuevo.'
    end
  end

  private

  def next_question_path
    # Lógica para determinar la siguiente pregunta
  end
end
