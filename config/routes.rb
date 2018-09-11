Rails.application.routes.draw do
  devise_for :user
  root to: 'user/journeys#index'

  namespace :user do
    resources :bags, only: %i[create update destroy]
    resources :items, only: %i[index create update destroy]
    resources :packed_items, only: %i[create destroy]
    resources :packed_bags, only: %i[index show create update destroy]
    resources :journeys, only: %i[index show create update destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
