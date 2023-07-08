Rails.application.routes.draw do
  resources :square_connectors
  get "callback", to: 'square_connectors#callback'
  resources :orders
  root 'square_connectors#new'
end
