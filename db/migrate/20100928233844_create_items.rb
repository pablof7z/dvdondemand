class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :title
      t.float :runtime
      t.references :publisher
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
