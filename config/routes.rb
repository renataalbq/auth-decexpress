Rails.application.routes.draw do
  resource :users, only: [:create]
  post "/login", to: "users#login"
  get "/users", to: "users#index"
  delete "/users/:id", to: "users#destroy"
end
