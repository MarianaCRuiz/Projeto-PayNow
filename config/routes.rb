Rails.application.routes.draw do

  devise_for :users
  root 'home#index'
  get 'receipts', to: 'home#receipts'

  namespace :client_admin do
    resources :companies, only: %i[show new create edit update], param: :token do
      get 'payments_chosen', on: :collection
      patch 'token_new', on: :member
      resources :products, only: %i[index show new create edit update], param: :token do
        patch "product_status", on: :member
      end
    end
    resources :charges, only: %i[index edit update], param: :token do
      get 'all_charges', on: :collection
      get 'thirty_days', on: :collection
      get 'ninety_days', on: :collection
    end
    resources :payment_options, only: %i[index] do
      resources :boleto_register_options, only: %i[new create edit update] do
        patch 'exclude', on: :member
      end
      resources :credit_card_register_options, only: %i[new create edit update] do
        patch 'exclude', on: :member
      end
      resources :pix_register_options, only: %i[new create edit update] do
        patch 'exclude', on: :member
      end
    end
  end
  namespace :clients do
    resources :companies, only: %i[show], param: :token do
      get 'payments_chosen', on: :collection
      #resources :products, only: %i[index show new create edit update], param: :token
    end
  end

  namespace :api do
    namespace :v1 do
      post 'charges', to: 'companies#charges'
      post 'final_clients', to: 'companies#final_clients'
      get 'consult_charges', to: 'companies#consult_charges'
      patch 'change_status', to: 'companies#change_status'
    end
  end

  namespace :admin do
    resources :payment_options, only: %i[index new create edit update]
    resources :companies, only: %i[index show edit update], param: :token do
      patch 'token_new', on: :member
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
