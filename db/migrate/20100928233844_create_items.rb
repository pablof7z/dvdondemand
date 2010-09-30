class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :title
      t.string :artist
      t.string :genre
      t.string :media_type
      t.integer :running_time
      t.references :publisher
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
