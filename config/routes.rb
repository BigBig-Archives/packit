Rails.application.routes.draw do
  devise_for :user
  root to: 'user/bags#index'

  namespace :user do
    resources :bags, only: %i[create update destroy]
    resources :items, only: %i[create update destroy]
    resources :packed_items, only: %i[create update destroy]
    resources :bags, only: %i[index show new create update destroy]
    get 'bags/:id/copy', to: 'bags#copy', as: 'bag_copy'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
