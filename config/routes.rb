Rails.application.routes.draw do

  devise_for :users
  root 'home#index'

  namespace :client_admin do
    resources :companies, only: %i[show new create], param: :token do
      
    end
    resources :payment_options, only: %i[index edit update]
  end
  
  namespace :admin do
    resources :payment_options, only: %i[index new create]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
