class AddUserFeedbackToUserScores < ActiveRecord::Migration[7.1]
  def change
    add_column :user_scores, :user_feedback, :text
  end
end
