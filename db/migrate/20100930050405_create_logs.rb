class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.integer :loggeable_id
      t.string  :loggeable_type
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
