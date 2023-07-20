Rails.application.routes.draw do
  resources :square_connectors do
    get 'refresh_token', on: :member
  end
  get "callback", to: 'square_connectors#callback'
  resources :orders
  root 'square_connectors#index'
end
