class DeviseCreateWholesalers < ActiveRecord::Migration
  def self.up
    create_table(:wholesalers) do |t|
      t.string :email
      t.string :name
      
      t.database_authenticatable :null => false
      t.rememberable
      t.trackable

      t.timestamps
    end
  end

  def self.down
    drop_table :wholesalers
  end
end
