class CreateMails < ActiveRecord::Migration
  def change
    create_table :mails do |t|
      t.integer :batch_id
      t.integer :sender_id
      t.string :sender_name
      t.string :sender_image
      t.integer :receiver_id
      t.string :receiver_name
      t.string :receiver_image
      t.string :title
      t.text :content
      t.string :redis_mail

      t.timestamps
    end
  end
end
