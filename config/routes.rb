Rails.application.routes.draw do

  devise_for :users
  root 'home#index'

  namespace :client_admin do
    resources :companies, only: %i[show new create edit update], param: :token do
      get 'payment_chosen', on: :collection
      resources :products, only: %i[index show new create edit update], param: :token
    end
    resources :payment_options, only: %i[index] do
      resources :boleto_register_options, only: %i[new create edit update]
      resources :credit_card_register_options, only: %i[new create edit update]
      resources :pix_register_options, only: %i[new create edit update]
    end
  end
  namespace :clients do
    resources :companies, only: %i[show], param: :token do
      get 'payment_chosen', on: :collection
      #resources :products, only: %i[index show new create edit update], param: :token
    end
  end
  namespace :api do
    namespace :v1 do
      post 'final_clients', to: 'api_companies#final_clients'
      post 'charges', to: 'api_companies#charges'
      #'charge_consult', to: 'api_companies#charge_consult'
    end
  end
  namespace :admin do
    resources :payment_options, only: %i[index new create edit update]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
