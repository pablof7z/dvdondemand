class DeviseCreateAffiliates < ActiveRecord::Migration
  def self.up
    create_table(:affiliates) do |t|
      t.string :email
      t.string :name
      
      t.database_authenticatable :null => false
      t.rememberable
      t.trackable

      t.timestamps
    end
    
    add_column :publishers, :affiliate_id, :integer
    add_column :publishers, :affiliate_introduction_id, :integer
  end

  def self.down
    drop_table :affiliates
    remove_column :publishers, :affiliate_id
    remove_column :publishers, :affiliate_introduction_id
  end
end
