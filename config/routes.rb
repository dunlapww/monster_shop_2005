Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "merchants#index"

  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  get "/merchants/:id", to: "merchants#show"
  post "/merchants", to: "merchants#create"
  get "/merchants/:id/edit", to: "merchants#edit"
  patch "/merchants/:id", to: "merchants#update"
  delete "/merchants/:id", to: "merchants#destroy"
  # This is going to change
  get '/merchant', to: 'merchant/dashboard#show'
  #patch '/merchant/items', to: 'merchant/items#update'
  namespace :merchant do
    resources :items, except: [:show]
    resources :orders, only: :show
  end

  resources :item_orders, only: :update

  get "/items", to: "items#index"
  get "/items/:id", to: "items#show"
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  delete "/items/:id", to: "items#destroy"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch '/cart/:item_id/add', to: "cart#increment_item"
  patch '/cart/:item_id/subtract', to: 'cart#decrement_item'

  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"
  get "/orders/:id", to: "orders#show"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"
  #users
  get "/register", to: "users#new"
  post "/users", to: "users#create"
  get "/profile", to: "users#show"
  get "/profile/edit", to: "users#edit"
  patch "/users", to: "users#update"

  namespace :profile do
    resources :orders, only: :index
  end
  get "/profile/orders/:id", to: "orders#show"
  patch '/profile/orders/:id', to: "orders#update"
  #password
  get '/profile/edit_password', to: 'passwords#edit'
  patch '/passwords', to: 'passwords#update'

  namespace :admin do
    resources :orders, only: :update
    resources :merchants, only: [:show, :index, :update]
    resources :users, only: [:index, :show]
    resources :merchants, only: :show do
      resources :items, only: [:index, :new]
    end
  end

  get '/admin', to: 'admin#show'
end
