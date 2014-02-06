Dummy::Application.routes.draw do
  mount UserDefinedAttributes::Engine, at: 'user_defined_attributes'
end
