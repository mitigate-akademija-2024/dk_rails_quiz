require 'csv'

class Quiz < ApplicationRecord
  
  validates :title, presence: true, uniqueness: true
  
  before_validation :normalize_title
  before_save :normalize_description

  has_many :questions, dependent: :destroy
  has_many :user_scores, dependent: :destroy

  belongs_to :user

  def self.to_csv
    attributes = %w{quiz_title user_email score feedback submitted_at}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.includes(user_scores: :user).each do |quiz|
        quiz.user_scores.each do |user_score|
          csv << [
            quiz.title,
            user_score.user.email,
            user_score.score,
            user_score.user_feedback,
            user_score.created_at.strftime("%Y-%m-%d %H:%M:%S")
          ]
        end
      end
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["title", "description"] # List all attributes that you want to allow for searching
  end
  
  protected

  def normalize_title
    Rails.logger.info("Quiz#normalize_title called")
    self.title = title.to_s.squish.capitalize
  end

  def normalize_description
    Rails.logger.info("Quiz#normalize_description called")
    self.description = description.to_s.squish
  end
end