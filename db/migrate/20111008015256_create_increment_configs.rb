class CreateIncrementConfigs < ActiveRecord::Migration
  def change
    create_table :increment_configs do |t|
      t.string :TABLE_NAME
      t.integer :TABLE_TOTAL
      t.string :COLUMN_NAME
      t.integer :START_VALUE
      t.integer :OFFSET_VALUE
      t.integer :FLAG
      t.date :GMT_MODIFIED

      t.timestamps
    end
  end
end
