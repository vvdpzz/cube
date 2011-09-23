class CreateMoneyTransactions < ActiveRecord::Migration
  def change
    create_table :money_transactions do |t|
      t.references :user
      t.references :winner
      t.references :question
      t.references :answer
      t.decimal :value, :precision => 8, :scale => 2
      t.boolean :payment, :default => true
      t.integer :trade_type
      t.integer :trade_status

      t.timestamps
    end
    add_index :money_transactions, :user_id
    add_index :money_transactions, :winner_id
    add_index :money_transactions, :question_id
    add_index :money_transactions, :answer_id
  end
end
