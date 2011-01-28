class Customer < ActiveRecord::Base
  has_one :cart
  has_many :cart_items
  has_many :orders
  has_many :product_flags
  has_many :customer_payments
  belongs_to :wholesaler

  devise :database_authenticatable, :confirmable, :recoverable, :registerable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name, :last_name, :address1, :city, :country
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_uniqueness_of :email, :scope => :wholesaler_id

  def full_name
    "#{first_name} #{last_name}"
  end

  def update_with_password(params)
    if params[:password].blank? and params[:password_confirmation].blank? and params[:current_password].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
      params.delete(:current_password)
      update_attributes(params)
    else
      super
    end
  end
end

