Rails.application.routes.draw do
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
 

  # Defines the root path route ("/")
root "cleaning_predictor#index"

  resource :apartment_transaction
  
  resources :transactions 
  resources :cleaning 
  resources :deposits
  resources :cleaning_predictor
  resources :requests do 
    member do 
      post '/upload-id', to: 'requests#upload_id'
      post '/pay-deposit', to: 'requests#pay_deposit'
      post '/agree-to-terms', to: 'requests#agree_to_terms'
      post '/capture-deposit', to: 'requests#capture_deposit'
      post '/release-deposit', to: 'requests#release_deposit'
      get '/preview-id', to: 'requests#preview_id'
    end
  
  end
  resources :bookings

  post '/apartment_transactions', to: 'apartment_transactions#create_many'
  
  get '/data', to: 'data#index'
  get '/apartments/previous-codes', to: 'apartments#previous_codes'
  post '/deposits/create-intent', to: 'deposits#create_intent'
end
