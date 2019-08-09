Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # get :root, to: 'welcome#index'
  #
  # resources :merchants do
  #   resources :items, only: [:index]
  # end
  #
  # resources :items, only: [:index, :show] do
  #   resources :reviews, only: [:new, :create]
  # end
  #
  # resources :reviews, only: [:edit, :update, :destroy]
  #
  # get '/cart', to: 'cart#show'
  # post '/cart/:item_id', to: 'cart#add_item'
  # delete '/cart', to: 'cart#empty'
  # patch '/cart/:change/:item_id', to: 'cart#update_quantity'
  # delete '/cart/:item_id', to: 'cart#remove_item'
  #
  # get '/registration', to: 'users#new', as: :registration
  # resources :users, only: [:create, :update] do
  #   resources :addresses, only: [:new, :create, :edit, :update, :destroy]
  # end
  # patch '/user/:id', to: 'users#update'
  # get '/profile', to: 'users#show'
  # get '/profile/edit', to: 'users#edit'
  # get '/profile/edit_password', to: 'users#edit_password'
  # post '/orders', to: 'user/orders#create'
  # get '/profile/orders', to: 'user/orders#index'
  # get '/profile/orders/:id', to: 'user/orders#show'
  # get '/profile/orders/:id/edit', to: 'user/orders#edit'
  # patch '/profile/orders/:id', to: 'user/orders#update'
  # delete '/profile/orders/:id', to: 'user/orders#cancel'
  #
  # get '/login', to: 'sessions#new'
  # post '/login', to: 'sessions#login'
  # get '/logout', to: 'sessions#logout'
  #
  # namespace :merchant do
  #   get '/', to: 'dashboard#index', as: :dashboard
  #   resources :orders, only: :show
  #   resources :items, only: [:index, :new, :create, :edit, :update, :destroy]
  #   put '/items/:id/change_status', to: 'items#change_status'
  #   get '/orders/:id/fulfill/:order_item_id', to: 'orders#fulfill'
  # end
  #
  # namespace :admin do
  #   get '/', to: 'dashboard#index', as: :dashboard
  #   resources :merchants, only: [:show, :update]
  #   resources :users, only: [:index, :show]
  #   patch '/orders/:id/ship', to: 'orders#ship'
  # end

  # MOD 3 PREWORK: Rewritten Routes
  get '/root', to: 'welcome#index', as: :root

  get '/merchants', to: 'merchants#index'
  post '/merchants', to: 'merchants#create'
  get '/merchants/new', to: 'merchants#new', as: :new_merchant
  get '/merchants/:id/edit', to: 'merchants#edit', as: :edit_merchant
  get '/merchants/:id', to: 'merchants#show', as: :merchant
  patch '/merchants/:id', to: 'merchants#update'
  delete '/merchants/:id', to: 'merchants#destroy'
  get '/merchants/:merchant_id/items', to: 'items#index', as: :merchant_items

  get '/items', to: 'items#index'
  get '/items/:id', to: 'items#show', as: :item
  get '/items/:item_id/reviews/new', to: 'reviews#new', as: :new_item_review
  post '/items/:item_id/reviews', to: 'reviews#create', as: :item_reviews

  get '/reviews/:id/edit', to: 'reviews#edit', as: :edit_review
  patch '/reviews/:id', to: 'reviews#update', as: :review
  delete '/reviews/:id', to: 'reviews#destroy'

  get '/cart', to: 'cart#show'
  post '/cart/:item_id', to: 'cart#add_item'
  delete '/cart', to: 'cart#empty'
  patch '/cart/:change/:item_id', to: 'cart#update_quantity'
  delete '/cart/:item_id', to: 'cart#remove_item'

  get '/registration', to: 'users#new', as: :registration

  post '/users', to: 'users#create'
  patch '/users/:id', to: 'users#update', as: :user

  get '/users/:user_id/addresses/new', to: 'addresses#new', as: :new_user_address
  post '/users/:user_id/addresses', to: 'addresses#create', as: :user_addresses
  get '/users/:user_id/addresses/:id/edit', to: 'addresses#edit', as: :edit_user_address
  patch '/users/:user_id/addresses/:id', to: 'addresses#update', as: :user_address
  delete '/users/:user_id/addresses/:id', to: 'addresses#destroy'

  patch '/user/:id', to: 'users#update'

  get '/profile', to: 'users#show', as: :profile
  get '/profile/edit', to: 'users#edit', as: :profile_edit
  get '/profile/edit_password', to: 'users#edit_password', as: :profile_edit_password

  post '/orders', to: 'user/orders#create'
  get '/profile/orders', to: 'user/orders#index', as: :profile_orders
  get '/profile/orders/:id', to: 'user/orders#show'
  get '/profile/orders/:id/edit', to: 'user/orders#edit'
  patch '/profile/orders/:id', to: 'user/orders#update'
  delete '/profile/orders/:id', to: 'user/orders#cancel'

  get '/login', to: 'sessions#new', as: :login
  post '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout', as: :logout

  get '/merchant', to: 'merchant/dashboard#index', as: :merchant_dashboard
  get '/merchant/orders/:id', to: 'merchant/orders#show', as: :merchant_order
  get '/merchant/items', to: 'merchant/items#index'
  get '/merchant/items/new', to: 'merchant/items#new', as: :new_merchant_item
  post '/merchant/items', to: 'merchant/items#create'
  get '/merchant/items/:id/edit', to: 'merchant/items#edit', as: :edit_merchant_item
  patch '/merchant/items/:id', to: 'merchant/items#update', as: :merchant_item
  put '/merchant/items/:id', to: 'merchant/items#update'
  delete '/merchant/items/:id', to: 'merchant/items#destroy'
  put '/merchant/items/:id/change_status', to: 'merchant/items#change_status'
  get '/merchant/orders/:id/fulfill/:order_item_id', to: 'merchant/orders#fulfill'

  get '/admin', to: 'admin/dashboard#index', as: :admin_dashboard
  get '/admin/merchants/:id', to: 'admin/merchants#show', as: :admin_merchant
  patch '/admin/merchants/:id', to: 'admin/merchants#update'
  get '/admin/users', to: 'admin/users#index', as: :admin_users
  get '/admin/users/:id', to: 'admin/users#show', as: :admin_user
  patch '/admin/orders/:id/ship', to: 'admin/orders#ship', as: :admin
end
