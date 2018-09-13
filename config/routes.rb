Rails.application.routes.draw do
  devise_for :user
  root to: 'user/journeys#index'

  namespace :user do
    resources :bags, only: %i[create update destroy]
    resources :items, only: %i[index create update destroy]
    resources :packed_items, only: %i[create update]
    resources :packed_bags, only: %i[index show create update destroy]
    get 'packed_bags/:id/copy', to: 'packed_bags#copy', as: 'packed_bag_copy'
    resources :journeys, only: %i[index show create update destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
