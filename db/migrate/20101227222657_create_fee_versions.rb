class CreateFeeVersions < ActiveRecord::Migration
  def self.up
    create_table :fee_versions do |t|
      t.references :sale
      t.references :fee
      t.integer :number

      t.timestamps
    end
  end

  def self.down
    drop_table :fee_versions
  end
end
