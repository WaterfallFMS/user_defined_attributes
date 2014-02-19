Dummy::Application.routes.draw do
  namespace :user_defined_attributes do
    resources :field_types, except: :show
  end

  resources :leads

  root to: 'root#index'
end
