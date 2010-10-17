class Publisher < ActiveRecord::Base
  has_many :catalogs, :dependent => :delete_all
  has_many :products
  has_many :items
  has_many :sales
  has_many :publisher_payments

  named_scope :approved, :conditions => { :approved => true }

  # don't add :confirmable just yet, until the mailer is configured
  devise :database_authenticatable, :recoverable, :registerable, :rememberable, :trackable, :validatable

  def full_name
    "#{first_name} #{last_name}"
  end
end

