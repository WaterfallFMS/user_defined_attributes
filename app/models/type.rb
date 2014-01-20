module UserDefinedAttributes
  class Type < ActiveRecord::Base
    has_many :user_defined_fields, :dependent => :destroy

    scope :default_sort, order('lower(name)')

    validates :name,       :presence => true, :uniqueness => {:scope => :model_type}
    validates :model_type, :presence => true
    validates :data_type,  :presence => true

    # todo: remove after user defined types can be used on other types
    before_validation :set_defaults
    def set_defaults
      self.model_type = Franchise.to_s if model_type.blank?
      self.data_type  = 'text' if data_type.blank?
    end
  end
end