Rails.application.routes.draw do
  devise_for :user
  root to: 'pages#home'
  resources :bags, only: %i[index show]
  resources :items, only: %i[index show]

  namespace :user do
    get 'dashboard', to: 'dashboard#show'
    resources :user_bags
    resources :user_items
    resources :user_packed_item
    resources :user_packed_bags
    resources :journeys
    resources :journey_bags
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
