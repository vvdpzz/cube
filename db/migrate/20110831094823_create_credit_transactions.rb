class CreateCreditTransactions < ActiveRecord::Migration
  def change
    create_table :credit_transactions do |t|
      t.references :user
      t.references :winner
      t.references :question
      t.references :answer
      t.boolean :payment, :default => true
      t.integer :value
      t.integer :trade_type
      t.integer :trade_status

      t.timestamps
    end
    add_index :credit_transactions, :user_id
    add_index :credit_transactions, :winner_id
    add_index :credit_transactions, :question_id
    add_index :credit_transactions, :answer_id
  end
end
