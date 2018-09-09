Rails.application.routes.draw do
  devise_for :user
  root to: 'pages#home'
  resources :bag_refs, only: %i[index]
  resources :item_refs, only: %i[index]

  namespace :user do
    get 'dashboard', to: 'dashboard#show'
    resources :bags, only: %i[create update destroy]
    resources :items, only: %i[create update destroy]
    resources :packed_item
    resources :packed_bags
    resources :journeys, only: %i[index show create update destroy]
    resources :journey_bags
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
