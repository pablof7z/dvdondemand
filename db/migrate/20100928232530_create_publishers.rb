class CreatePublishers < ActiveRecord::Migration
  def self.up
    create_table :publishers do |t|
      t.string :name
      t.text :address
      t.boolean :is_approved
      t.timestamps
    end
  end

  def self.down
    drop_table :publishers
  end
end
