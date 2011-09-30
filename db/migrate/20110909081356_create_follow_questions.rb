class CreateFollowQuestions < ActiveRecord::Migration
  def change
    create_table :follow_questions do |t|
      t.references :user
      t.integer :question_id, :limit => 8, :null => false

      t.timestamps
    end
    add_index :follow_questions, :user_id
    add_index :follow_questions, :question_id
  end
end
