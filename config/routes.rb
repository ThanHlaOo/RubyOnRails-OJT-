Rails.application.routes.draw do
  # get 'user/index'
  root 'posts#index' 

  get "/articles", to: "article#index"
  get "/articles/:id", to: "article#show"

  resources :posts
  get "/login", to: "user#login"
  post "/login", to: "user#create"
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
  get "/user/:name/cancle", to: "user#cancle" , as: :user_cancle
  post "/user/registerConfirm", to: "user#confirmRegister"
  post "/user/register", to: "user#saveRegister"
  get "/user/profile", to: "user#profile"
  delete '/users/:id/delete', to: 'user#destroy', as: :delete_user
  get '/user/:id/edit', to: 'user#editProfile', as: :edit_profile
  patch '/user/:id/edit', to: 'user#updateProfile', as: :update_profile
  post "/users/search", to: "user#search"
  get '/password/edit', to: 'user#edit_password'
  patch '/password', to: 'user#update_password'
  get "/password/reset", to: "password_resets#new"
  post "/password/reset", to: "password_resets#create"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
