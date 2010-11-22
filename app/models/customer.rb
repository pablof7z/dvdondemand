class Customer < ActiveRecord::Base
  has_one :cart
  has_many :orders
  has_many :product_flags
  has_many :customer_payments

  devise :database_authenticatable, :confirmable, :recoverable, :registerable, :rememberable, :trackable, :validatable

  def full_name
    "#{first_name} #{last_name}"
  end
end

