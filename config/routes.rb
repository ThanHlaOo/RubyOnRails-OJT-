Rails.application.routes.draw do
  # get 'user/index'
  root 'posts#index' 

  get "/articles", to: "article#index"
  get "/articles/:id", to: "article#show"

  resources :posts
  get "/login", to: "user#login"
  post "/login", to: "user#create"
  get "/register", to: "user#register"
  post "/register", to: "user#saveRegister"
  get "/logout", to: "user#logout"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
