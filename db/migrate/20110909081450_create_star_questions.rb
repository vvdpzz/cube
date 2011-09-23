class CreateStarQuestions < ActiveRecord::Migration
  def change
    create_table :star_questions do |t|
      t.references :user
      t.references :question

      t.timestamps
    end
    add_index :star_questions, :user_id
    add_index :star_questions, :question_id
  end
end
