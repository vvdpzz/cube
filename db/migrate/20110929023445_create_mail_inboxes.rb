class CreateMailInboxes < ActiveRecord::Migration
  def change
    create_table :mail_inboxes do |t|
      t.integer :user_id
      t.integer :batch_id
      t.integer :mail_id
      t.string  :redis_mail

      t.timestamps
    end
  end
end
