Rails.application.routes.draw do
  get '/search',to: 'youtubeapi_pages#search'
  get '/show' , to: 'youtubeapi_pages#show'
  get 'password_resets/new'
  get 'password_resets/edit'
  root 'static_pages#home'
  get 'static_pages/home'
  get '/help',to:'static_pages#help'
  get '/about',to:'static_pages#about'
  get  '/signup',  to: 'users#new'
  #8章で追記
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  #14章
  resources :users do
    member do
      get :following, :followers
    end
  end
  #7章　下記の一行だけでいろんなアクションが使えるようになる！便利！
  resources :users
  #11章
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  #13章
  resources :microposts,          only: [:create, :destroy,:show]
  #14章
  resources :relationships,       only: [:create, :destroy]
end