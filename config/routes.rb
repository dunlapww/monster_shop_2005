Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "merchants#index"

  # get "/merchants", to: "merchants#index"
  # get "/merchants/new", to: "merchants#new"
  # get "/merchants/:id", to: "merchants#show"
  # post "/merchants", to: "merchants#create"
  # get "/merchants/:id/edit", to: "merchants#edit"
  # patch "/merchants/:id", to: "merchants#update"
  # delete "/merchants/:id", to: "merchants#destroy"
  resources :merchants
  
  #below can't be converted to resources syntax...
  get '/merchant', to: 'merchant/dashboard#show'
  

  # namespace :merchant do
  #   #resources :items, except: [:show]
  # end
  get '/merchant/items', to: 'merchant/items#index'
  get '/merchant/items/new', to: 'merchant/items#new', as: 'new_merchant_item'
  post '/merchant/items', to: 'merchant/items#create'
  get '/merchant/items/:id/edit', to: 'merchant/items#edit', as: 'edit_merchant_item'
  patch '/merchant/items/:id', to: 'merchant/items#update', as: 'merchant_item'
  delete '/merchant/items/:id', to: 'merchant/items#destroy'
  
  # namespace :merchant do
  #   resources :orders, only: :show
  # end
  get '/merchant/orders/:id', to: 'merchant/orders#show', as: 'merchant_order'

  #resources :item_orders, only: :update
  patch "/item_orders/:id", to: 'item_orders#update'


  resources :items, only: [:index, :show, :edit, :update]
  # get "/items", to: "items#index"
  # get "/items/:id", to: "items#show"
  # get "/items/:id/edit", to: "items#edit"
  # patch "/items/:id", to: "items#update"

  #below can't be converted resources syntax...
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  
  resources :items, only: :destroy
  #delete "/items/:id", to: "items#destroy"

  #below can't be converted to resources syntax...
  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  resources :reviews, only: [:edit, :update, :destroy]
  # get "/reviews/:id/edit", to: "reviews#edit"
  # patch "/reviews/:id", to: "reviews#update"
  # delete "/reviews/:id", to: "reviews#destroy"

  #below can't be converted to resources syntax...
  post "/cart/:item_id", to: "cart#add_item"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch '/cart/:item_id/add', to: "cart#increment_item"
  patch '/cart/:item_id/subtract', to: 'cart#decrement_item'
  delete "/cart", to: "cart#empty"
  get "/cart", to: "cart#show"
  
  # get "/orders/new", to: "orders#new"
  # post "/orders", to: "orders#create"
  # get "/orders/:id", to: "orders#show"
  resources :orders, only: [:new, :create, :show]

  #below can't be converted to resoures syntax...
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"
  
  # post "/users", to: "users#create"
  resources :users, only: :create
  
  #below can't be converted to resources syntax...
  patch "/users", to: "users#update"
  get "/register", to: "users#new"
  get "/profile", to: "users#show"
  get "/profile/edit", to: "users#edit"

  # namespace :profile do
  #   resources :orders, only: :index
  # end
  get "profile/orders", to: 'profile/orders#index'

  # get "/profile/orders/:id", to: "orders#show"
  # patch '/profile/orders/:id', to: "orders#update"
  scope :profile do
    resources :orders, only: [:show, :update]
  end
  
  #below can't be converted to resources syntax...
  get '/profile/edit_password', to: 'passwords#edit'
  patch '/passwords', to: 'passwords#update'

  # namespace :admin do
  #   resources :orders, only: :update
  # end
  patch '/admin/orders/:id', to: 'admin/orders#update'

  # namespace :admin do
  #   resources :merchants, only: [:show, :index, :update]
  # end
  get '/admin/merchants/:id', to: 'admin/merchants#show'
  patch '/admin/merchants/:id', to: 'admin/merchants#update'
  get '/admin/merchants', to: 'admin/merchants#index'

  
  # namespace :admin do
  #   resources :users, only: [:index, :show] do
  #     resources :orders, only: :index
  #   end
  # end
  get '/admin/users', to: 'admin/users#index', as: 'admin_users'
  get '/admin/users/:id', to: 'admin/users#show', as: 'admin_user'
  get '/admin/users/:user_id/orders', to: 'admin/orders#index', as: 'admin_user_orders'
  

  # namespace :admin do
  #   resources :merchants, only: :show do
  #     resources :items, only: [:index, :new]
  #   end
  # end
  get '/admin/merchants/:id', to: 'admin/merchants#show', as: 'admin_merchant'
  get '/admin/merchants/:merchant_id/items', to: 'admin/items#index', as: 'admin_merchant_items'
  get '/admin/merchants/:merchant_id/items/new', to: 'admin/items#new', as: 'new_admin_merchant_item'

  #below can't be converted to resources syntax... 
  get '/admin', to: 'admin#show'
end
