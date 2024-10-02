Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  resource :apartment_transaction
  
  resources :cleaning 
  resources :deposits 

  
  post '/apartment_transactions', to: 'apartment_transactions#create_many'
  
  get '/cleans', to: 'home#cleans'
  get '/data', to: 'data#index'
end
