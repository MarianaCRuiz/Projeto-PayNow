Rails.application.routes.draw do

  devise_for :users
  root 'home#index'

  namespace :client_admin do
    resources :companies, only: %i[show new create], param: :token do
      get 'payment_chosen', on: :collection
      resources :products, only: %i[index show new create], param: :token
    end
    resources :payment_options, only: %i[index] do
      resources :boleto_register_options, only: %i[new create]
      resources :credit_card_register_options, only: %i[new create]
      resources :pix_register_options, only: %i[new create]
    end
  end
  
  namespace :admin do
    resources :payment_options, only: %i[index new create edit update]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
