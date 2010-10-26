class Genre < ActiveRecord::Base
  validates_presence_of :title
end

