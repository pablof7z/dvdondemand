class Customer < ActiveRecord::Base
  has_many :orders
  has_many :product_flags
  has_many :customer_payments

  # don't add :confirmable just yet, until the mailer is configured
  devise :database_authenticatable, :recoverable, :registerable, :rememberable, :trackable, :validatable
end

