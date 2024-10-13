Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  resource :apartment_transaction
  
  resources :transactions 
  resources :cleaning 
  resources :deposits
  resources :cleaning_predictor
  resources :requests

  post '/apartment_transactions', to: 'apartment_transactions#create_many'
  
  get '/data', to: 'data#index'
  get '/apartments/previous-codes', to: 'apartments#previous_codes'
end
