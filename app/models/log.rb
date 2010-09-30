class Log < ActiveRecord::Base
  ##########################
  # Associations
  ##########################
  belongs_to :loggeable, :polymorphic => true
  
end
