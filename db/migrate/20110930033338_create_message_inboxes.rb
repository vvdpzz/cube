class CreateMessageInboxes < ActiveRecord::Migration
  def change
    create_table :message_inboxes do |t|
      t.integer :user_id
      t.integer :batch_id
      t.integer :message_id

      t.timestamps
    end
  end
end
