class AddQuizResultsToUserScores < ActiveRecord::Migration[6.1]
  def change
    add_column :user_scores, :question_results, :text
    add_column :user_scores, :correct_count, :integer
    add_column :user_scores, :total_questions, :integer
  end
end