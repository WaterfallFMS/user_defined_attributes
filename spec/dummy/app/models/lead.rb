class Lead < ActiveRecord::Base
  include UDA

  validates :name,  :presence => true
  validates :email, :presence => true
end
