class Lead < ActiveRecord::Base
  include UserDefinedAttributes::Model

  validates :name,  :presence => true
end
