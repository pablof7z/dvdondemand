class CreateAffiliateIntroductions < ActiveRecord::Migration
  def self.up
    create_table :affiliate_introductions do |t|
      t.integer :affiliate_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :signup_hash

      t.timestamps
    end
  end

  def self.down
    drop_table :affiliate_introductions
  end
end
