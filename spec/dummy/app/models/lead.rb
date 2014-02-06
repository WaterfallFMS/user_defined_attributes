class Lead < ActiveRecord::Base
  include UDA

  validates :name,  :presence => true
end
