class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :receiver_id
      t.integer :sender_id
      t.string :sender_name
      t.string :description
      t.integer :subject_id
      t.string :subject_content
      t.integer :object_id
      t.string :object_content
      t.boolean :read

      t.timestamps
    end
  end
end
