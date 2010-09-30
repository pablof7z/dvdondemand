class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.string :module
      t.integer :level
      t.string :data

      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
