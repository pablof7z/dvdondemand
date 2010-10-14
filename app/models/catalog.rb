class Catalog < ActiveRecord::Base
  belongs_to :publisher
  has_and_belongs_to_many :products
  has_one :facebook_catalog

  named_scope :public, :conditions => { :private => false }
  named_scope :private, :conditions => { :private => true }
end

