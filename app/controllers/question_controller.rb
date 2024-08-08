class QuestionController < ApplicationController
  def index
  end

  def create
  end

  def start
  end

  def test
  end

  def new
    @quiz = Quiz.find(params:[:quiz_id])
    @question = @quiz.questions.new
  end
end
