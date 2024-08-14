class Question < ApplicationRecord
  validates :question_text, presence: true
  
  belongs_to :quiz
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers, allow_destroy: true, reject_if: proc { |attributes| attributes['answer_text'].blank? }

  validates :point_value, numericality: { greater_than: 0 }, presence: true

  before_validation :set_default_point_value

  private

  def set_default_point_value
    self.point_value ||= 1
  end
end