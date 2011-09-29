class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers, :id => false do |t|
      t.integer :id, :limit => 8, :null => false
      # user info
      t.references :user, :null => false
      t.string :username, :null => false      
      t.string :about_me, :default => ""
      # FIXME: remember to add index on those FKs
      t.integer :question_id, :limit => 8, :null => false
      t.text :content, :null => false
      t.boolean :is_correct, :default => false
      t.integer :votes_count, :default => 0
      t.binary :comments, :limit => 10.megabyte
      t.timestamps
    end
    add_index :answers, :user_id
    add_index :answers, :question_id
  end
end
