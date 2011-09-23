class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions, :id => false do |t|
      t.integer :id, :limit => 8, :null => false
      t.references :user, :null => false
      t.string :title, :null => false
      t.text :content
      t.integer :credit, :default => 0
      t.decimal :money, :precision => 8, :scale => 2, :default => 0
      t.integer :answers_count, :default => 0
      t.integer :votes_count, :default => 0
      t.integer :correct_answer_id, :default => 0
      t.binary :comments, :limit => 10.megabyte
      t.timestamps
    end
    add_index :questions, :user_id
  end
end
