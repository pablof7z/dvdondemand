class CreateAffiliateIntroductions < ActiveRecord::Migration
  def self.up
    create_table :affiliate_introductions do |t|
      t.integer :affiliate_id
      t.string :hash
      t.boolean :used

      t.timestamps
    end
  end

  def self.down
    drop_table :affiliate_introductions
  end
end
