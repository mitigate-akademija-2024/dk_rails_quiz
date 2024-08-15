class UserScore < ApplicationRecord
  belongs_to :user
  belongs_to :quiz
  
  validates :user_feedback, 
    presence: { message: "Feedback cannot be empty" },
    length: { 
      minimum: 5, 
      maximum: 100, 
      too_short: "Feedback must be at least %{count} characters long",
      too_long: "Feedback too long (maximum is %{count} characters)"
    },
    on: :feedback_submission

  def self.top_scores_for_quiz(quiz, limit = 5)
    where(quiz: quiz)
      .order(score: :desc, created_at: :asc)
      .limit(limit)
      .includes(:user)
  end
end
