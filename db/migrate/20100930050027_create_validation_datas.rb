class CreateValidationDatas < ActiveRecord::Migration
  def self.up
    create_table :validation_datas do |t|
      t.integer :publisher_id
      t.float :deposit_1
      t.float :deposit_2
      t.string :bank
      t.integer :account
      t.integer :routing

      t.timestamps
    end
  end

  def self.down
    drop_table :validation_datas
  end
end
