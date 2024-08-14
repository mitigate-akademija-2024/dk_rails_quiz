class AddPointValueToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :point_value, :integer
  end
end
