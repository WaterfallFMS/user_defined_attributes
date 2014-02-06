Dummy::Application.routes.draw do
  mount UserDefinedAttributes::Engine, at: 'user_defined_attributes'

  root to: 'root#index'
end
