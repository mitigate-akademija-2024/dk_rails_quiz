class UserScore < ApplicationRecord
  belongs_to :user
  belongs_to :quiz
  def self.top_scores_for_quiz(quiz, limit = 5)
    where(quiz: quiz)
      .order(score: :desc, created_at: :asc)
      .limit(limit)
      .includes(:user)
  end
end
