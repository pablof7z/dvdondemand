class DeviseCreateAffiliates < ActiveRecord::Migration
  def self.up
    create_table(:affiliates) do |t|
      t.string :email
      t.string :name
      t.boolean :approved
      t.string :approval_source
      t.integer :commission_percentage, :default => DEFAULT_AFFILIATE_COMISSION_PERCENTAGE
      t.float :commission_per_unit, :default => DEFAULT_AFFILIATE_COMISSION_PER_UNIT
      
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
