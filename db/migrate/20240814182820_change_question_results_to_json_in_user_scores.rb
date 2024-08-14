class ChangeQuestionResultsToJsonInUserScores < ActiveRecord::Migration[6.1]
  def up
    change_column :user_scores, :question_results, :json, using: 'question_results::json'
  end

  def down
    change_column :user_scores, :question_results, :text
  end
end