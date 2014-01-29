module UserDefinedAttributes
  class Field < ActiveRecord::Base
    belongs_to :field_type
    belongs_to :model, :polymorphic => true
  end
end
