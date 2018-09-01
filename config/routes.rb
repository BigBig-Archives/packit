Rails.application.routes.draw do
  devise_for :user
  root to: 'pages#home'
  resources :bag_refs, only: %i[index show]
  resources :item_refs, only: %i[index show]

  namespace :user do
    get 'dashboard', to: 'dashboard#show'
    resources :bags
    resources :items
    resources :packed_item
    resources :packed_bags
    resources :journeys
    resources :journey_bags
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
