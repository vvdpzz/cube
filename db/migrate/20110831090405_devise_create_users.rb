class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :realname
      t.string :username, :null => false
      t.token_authenticatable
      t.database_authenticatable :null => false
      
      t.string :about_me, :default => ""
      
      t.integer :questions_count, :default => 0
      t.integer :answers_count, :default => 0
      
      t.integer :votes_count, :default => 0
      t.integer :vote_per_day, :default => 40
      t.integer :credit_today, :default => 0
      
      t.integer :gpa, :default => 0
      t.integer :credit, :default => 0
      t.decimal :money, :precision => 8, :scale => 2, :default => 0
      
      t.recoverable
      t.rememberable
      t.trackable

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :username,             :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    add_index :users, :authentication_token, :unique => true
  end
end
