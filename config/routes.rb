UserDefinedAttributes::Engine.routes.draw do
  resources :field_types, except: :show
end
