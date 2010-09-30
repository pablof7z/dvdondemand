class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.float :production_fee
      t.float :processing_fee
      t.float :royalty_commission

      t.timestamps
    end
  end

  def self.down
    drop_table :configurations
  end
end
