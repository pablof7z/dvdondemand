class Publisher < ActiveRecord::Base
  has_many :catalogs, :dependent => :delete_all
  has_many :products
  has_many :items
  has_many :sales
  has_many :publisher_payments

  named_scope :approved, :conditions => { :approved => true }

  devise :database_authenticatable, :confirmable, :recoverable, :registerable, :rememberable, :trackable, :validatable

  def full_name
    "#{first_name} #{last_name}"
  end

  def artist_name
    nickname || full_name
  end
end

