class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :address1
      t.string :address2
      t.string :company
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country

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

