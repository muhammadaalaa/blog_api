Rails.application.routes.draw do
  post 'signup', to: 'authentication#signup'
  post 'login', to: 'authentication#login'
  resources :posts do
    resources :comments, only: [:create, :update, :destroy]
  end
  resources :tags, only: [:create, :update, :destroy]


end 