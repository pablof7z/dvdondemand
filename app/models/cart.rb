class Cart < ActiveRecord::Base
  belongs_to :customer
  has_many :items, :class_name => 'CartItem', :dependent => :delete_all
  accepts_nested_attributes_for :items
end

