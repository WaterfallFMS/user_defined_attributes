module UserDefinedAttributes
  class Field < ActiveRecord::Base
    belongs_to :user_defined_type
    belongs_to :model, :polymorphic => true
  end
end
