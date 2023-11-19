Rails.application.routes.draw do
  resources :documents do
    member do
      get :generate_pdf
      get :download
    end
  end

  resource :users, only: [:create]
  post "/login", to: "users#login"
  get "/users", to: "users#index"
  delete "/users/:id", to: "users#destroy"
  post '/valid_token', to: 'users#validate_token'
end
