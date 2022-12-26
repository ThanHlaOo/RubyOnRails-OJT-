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
  get "/posts-confirm", to: "posts#confirm"
  get "/posts-edit-confirm", to: "posts#editConfirm"
  patch '/posts/:id', to: 'posts#update'
  get "/search", to: "posts#search"
  get "/import", to: "posts#import"
  post "posts/import", to: "posts#upload"
  get "/export", to: "posts#export"
  get "/users", to: "user#index"
  get "/users/new", to: "user#register"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
