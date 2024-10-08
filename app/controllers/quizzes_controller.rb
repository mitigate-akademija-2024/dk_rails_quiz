class QuizzesController < ApplicationController
  load_and_authorize_resource except: [:do_quiz, :result]
  before_action :set_quiz, only: %i[ show edit update destroy result do_quiz submit_quiz]

  # GET /quizzes or /quizzes.json
  def index
    @quizzes = Quiz.all

    @title = 'These are the quizzes'
    @description = 'lorem ipsum'
  end

  def start
    @title = 'Start some quiz'
    @description = 'lorem ipsum'

    respond_to do |format|
      format.html
      format.json do
        render json: { title: @title, description: "Šī ir json atbilde" }
      end
    end
  end

  # GET /quizzes/1 or /quizzes/1.json
  def show
  end

  # GET /quizzes/new
  def new
    @quiz = Quiz.new
  end

  # GET /quizzes/1/edit
  def edit
  end

  # POST /quizzes or /quizzes.json
  def create
    authorize! :create, @quiz
    @quiz = Quiz.new(quiz_params)

    respond_to do |format|
      if @quiz.save
        format.html do
          flash.notice = "Quiz was successfully created this time."
          redirect_to quiz_url(@quiz)
        end
        format.json { render :show, status: :created, location: @quiz }
      else
        flash.now.alert = 'Something went wrong'
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quizzes/1 or /quizzes/1.json
  def update
    authorize! :create, @quiz
    respond_to do |format|
      if @quiz.update(quiz_params)
        format.html { redirect_to quiz_url(@quiz), notice: "Quiz was successfully updated." }
        format.json { render :show, status: :ok, location: @quiz }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quizzes/1 or /quizzes/1.json
  def destroy
    @quiz.destroy!

    respond_to do |format|
      format.html { redirect_to quizzes_url, notice: "Quiz was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def do_quiz
    @questions = @quiz.questions.includes(:answers)
    authorize! :do_quiz, @quiz
  end

  def submit_quiz
    authorize! :submit_quiz, @quiz
    total_score = 0
    correct_count = 0
    @questions = @quiz.questions.includes(:answers)
    
    @questions.each do |question|
      selected_answer_id = params["question_#{question.id}"]
      if selected_answer_id && question.answers.find(selected_answer_id).correct
        total_score += question.point_value
        correct_count += 1
      end
    end

    user_score = UserScore.create(
      user: current_user,
      quiz: @quiz,
      score: total_score
    )

    redirect_to result_quiz_path(@quiz, score: total_score, correct_count: correct_count, total_questions: @questions.count)
  end

  def result
    authorize! :result, @quiz
    @score = params[:score]
    @correct_count = params[:correct_count].to_i
    @total_questions = params[:total_questions].to_i
    @correct_percentage = (@total_questions > 0) ? (@correct_count.to_f / @total_questions * 100).round(2) : 0
    @user_score = current_user.user_scores.find_by(quiz: @quiz)

    if @score.nil?
      flash[:alert] = "No score available. Please take the quiz first."
      redirect_to quiz_path(@quiz) and return
    end
  end

  def my_quizzes
    @quizzes = current_user.quizzes
  end
  
  def all_high_scores
    authorize! :read, Quiz
    @quizzes_with_scores = Quiz.joins(:user_scores)
                               .distinct
                               .order(:title)
    
    @top_scores = {}
    @quizzes_with_scores.each do |quiz|
      @top_scores[quiz.id] = UserScore.top_scores_for_quiz(quiz)
    end
  end

  def submit_feedback
    @user_score = current_user.user_scores.where(quiz: @quiz).last
    @user_score.assign_attributes(user_feedback_params)

    if @user_score.save(context: :feedback_submission)
      flash[:notice] = "Thank you for your feedback!"
      redirect_to all_feedback_quizzes_path
    else
      flash[:alert] = @user_score.errors.full_messages.join(", ")
      redirect_to result_quiz_path(@quiz, score: @user_score.score, correct_count: params[:correct_count], total_questions: params[:total_questions])
    end
  end

  def all_feedback
    @quizzes = Quiz.includes(user_scores: :user).order(:title)

    respond_to do |format|
      format.html
      format.csv { send_data Quiz.to_csv, filename: "all_quiz_highscores_#{Date.today}.csv" }
    end
  end

  def index
    @q = Quiz.ransack(params[:q])
    @quizzes = @q.result
  end
  
  def send_invitation
    authorize! :send_invitation, Quiz
    @quiz = Quiz.find(params[:id])
    email = params[:email]

    if email.present?
      QuizInvitationMailer.invite(email, @quiz, current_user).deliver_now
      redirect_to @quiz, notice: 'Invitation sent successfully!'
    else
      redirect_to do_quiz_quiz_path(@quiz), alert: 'Please provide an email address.'
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quiz_params
      params.require(:quiz).permit(:title, :description, :user_id)
    end

    def user_feedback_params
      params.require(:user_score).permit(:user_feedback)
    end
end