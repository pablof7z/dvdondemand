class CreateCreditCards < ActiveRecord::Migration
  def self.up
    create_table :credit_cards do |t|
      t.string :first_name
      t.string :last_name
      t.string :card_type
      t.string :card_number
      t.string :card_verification_value
      t.date :card_expires_on
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :company
      t.integer :wholesaler_id
      t.boolean :default

      t.timestamps
    end
  end

  def self.down
    drop_table :credit_cards
  end
end
