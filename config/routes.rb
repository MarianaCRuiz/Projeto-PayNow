Rails.application.routes.draw do

  devise_for :users
  root 'home#index'
  resources :receipts, only: %i[index] do
    post 'filter', on: :collection
  end
  namespace :client_admin do
    resources :companies, only: %i[show new create edit update], param: :token do
      member do
        get 'payments_chosen'
        patch 'token_new'
        get 'emails'
        patch 'block_email'
        patch 'unblock_email'
      end
      resources :products, only: %i[index show new create edit update], param: :token do
        patch "product_status", on: :member
      end
    end
    resources :charges, only: %i[index edit update], param: :token do
      collection do
        get 'all_charges'
        get 'time_interval'
      end
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
      get 'payments_chosen', on: :member
      resources :products, only: %i[index show new create edit update], param: :token do
        patch "product_status", on: :member
      end
    end
    resources :charges, only: %i[index], param: :token do
      collection do
        get 'all_charges'
        get 'time_interval'
      end
    end
  end

  namespace :admin do
    resources :payment_options, only: %i[index new create edit update]
    resources :companies, only: %i[index show edit update], param: :token do
      member do
        patch 'token_new'
        patch 'block_company'
        get 'emails'
        patch 'block_email'
        patch 'unblock_email'
      end
    end
    resources :charges, only: %i[index edit update], param: :token do
      get 'all_charges', on: :collection
    end
  end
  
  namespace :api do
    namespace :v1 do
      post 'charges', to: 'charges#charges_generate'
      post 'final_clients', to: 'final_clients#final_client_token'
      get 'consult_charges', to: 'queries#consult_charges'
      patch 'change_status', to: 'queries#change_status'
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
