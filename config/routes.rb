Rails.application.routes.draw do
  resources :grades do
    collection do
      get 'find_by_email', to: 'grades#find_by_email'
    end
  end
  
  resources :documents do
    member do
      get :generate_pdf
      get :download
      get :send_email, to: 'documents#send_email'
      get :generate_history, to: 'documents#generate_history'
      get :download_hist
      get :send_email_hist, to: 'documents#send_email_hist'
    end
  end

  resource :users, only: [:create]
  post "/login", to: "users#login"
  get "/users", to: "users#index"
  delete "/users/:id", to: "users#destroy"
  post '/valid_token', to: 'users#validate_token'
  post '/update_password', to: 'users#update_password'

  resources :teachers, only: [:index, :show]
  resources :subjects, only: [:index, :show]
end
