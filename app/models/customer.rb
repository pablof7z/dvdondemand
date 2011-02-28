class Customer < ActiveRecord::Base
  has_one :cart
  has_many :cart_items
  has_many :orders
  has_many :product_flags
  has_many :customer_payments
  belongs_to :wholesaler

  devise :database_authenticatable, :recoverable, :registerable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name, :last_name, :address1, :city, :country
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_uniqueness_of :email, :scope => :wholesaler_id

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.anonymous
    anonymous = create! do |c|
      c.first_name = 'Anonymous'
      c.last_name = 'User'
      c.address1 = '123 Anonymous St.'
      c.city = 'Anonymouspolis'
      c.country = 'Anonymousland'
      c.email = "#{rand(999999)}@anonymous.nil"
      c.password = 'anonymous'
      c.anonymous = true
    end
    anonymous
  end
end

