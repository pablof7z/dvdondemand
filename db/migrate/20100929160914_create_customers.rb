class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.text :address

      # Devise-specific
      t.database_authenticatable
      t.confirmable
      t.recoverable
      t.registerable
      t.rememberable
      t.trackable

      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end

