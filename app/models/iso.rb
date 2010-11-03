class Iso < ActiveRecord::Base
  belongs_to :product

  has_attached_file :iso
end

