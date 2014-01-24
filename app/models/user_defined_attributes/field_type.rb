  class UserDefinedAttributes::FieldType < ActiveRecord::Base
    has_many :user_defined_fields, :dependent => :destroy

    #scope :default_sort, order('lower(name)')

    validates :name,       :presence => true, :uniqueness => {:scope => :model_type}
    validates :model_type, :presence => true
    validates :data_type,  :presence => true
  end
