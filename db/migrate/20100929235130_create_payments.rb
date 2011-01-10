class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.references :owner, :polymorphic => true
      t.references :sale
      t.float      :amount
      # this columns are dummies and should be nuked ASAP
      t.string     :payment_gateway
      t.string     :transaction_code
      t.string     :status_code
      t.datetime   :date_processed
      t.integer    :check_number

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
