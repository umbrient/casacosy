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
  resources :linen_counter
  resources :requests do 
    member do 
      post '/capture-deposit', to: 'requests#capture_deposit'
      post '/release-deposit', to: 'requests#release_deposit'
      get '/preview-id', to: 'requests#preview_id'
    end
  end

  # post '/webhook', to: 'smoobu_listener#webhook'
  
  get '/linen_count', to: 'linen_counter#index'


  
  get '/guests/:reservation_id/', to: 'guests#no_code'

  scope '/guests/:reservation_id/:code(/:step)' do  
    post '/update-booking', to: 'guests#update_booking'
    post '/upload-id', to: 'guests#upload_id'
    post '/reupload-id', to: 'guests#reupload_id'
    post '/agree-to-terms', to: 'guests#agree_to_terms'
    post '/update-extras', to: 'guests#update_extras'
    post '/create-deposit-intent', to: 'guests#create_deposit_intent'
    post '/create-extras-intent', to: 'guests#create_extras_intent'
    post '/pay-deposit', to: 'guests#pay_deposit'
    post '/pay-extras', to: 'guests#pay_extras'

    get '/pay-deposit-remotely', to: 'guests#pay_deposit'
    get '/switch-extras-payment-method', to: 'guests#switch_extras_payment_method'
    get '/no-deposit', to: 'guests#no_deposit'


    # catch-alls and general should be last, generally
    get '/', to: 'guests#show'
  end 

  
  
  resources :bookings

  post '/apartment_transactions', to: 'apartment_transactions#create_many'

  get '/data', to: 'data#index'
  get '/apartments/previous-codes', to: 'apartments#previous_codes'
  
end
