class CreateFees < ActiveRecord::Migration
  def self.up
    create_table :fees do |t|
      t.string :description
      t.float :amount
      t.references :sale

      t.timestamps
    end
  end

  def self.down
    drop_table :fees
  end
end
