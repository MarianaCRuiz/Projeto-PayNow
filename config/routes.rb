Rails.application.routes.draw do

  devise_for :users
  root 'home#index'

  namespace :client_admin do
    resources :companies, only: %i[show new create], param: :token
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
