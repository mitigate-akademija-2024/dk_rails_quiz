class QuestionsController < ApplicationController
  load_and_authorize_resource except: [:create, :add_answer, :update, :edit]
  before_action :set_quiz, only: [:new, :create]
  before_action :set_question, only: [:destroy, :edit, :update]
  def index
  end

  def create
    authorize! :update, @quiz
    @question = @quiz.questions.new(question_params)
    if params[:commit] == "add_answer"
      @question.answers.new
      render :new, status: :unprocessable_entity
    else
      if @question.save
        flash.notice = "Question was successfully created."
        redirect_to quiz_url(@quiz)
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def new
    authorize! :new, @question
    @question = @quiz.questions.new
    @question.answers.new
  end

  def add_answer
    authorize! :add_answer, @question
    @question = @quiz.questions.new(question_params)
    @question.answers.news
    render :new
  end

  def destroy
    authorize! :destroy, @question
    @question.destroy
    redirect_to quiz_path(@question.quiz), notice: "Question has been destroyed."
  end

  def edit
    authorize! :edit, @question
  end

  def update
    authorize! :update, @question
    if @question.update(question_params)
      redirect_to quiz_url(@question.quiz), notice: "Question was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:question_text, answers_attributes: [:id, :answer_text, :correct, :_destroy])
  end


end