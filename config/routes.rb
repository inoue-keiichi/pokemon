Rails.application.routes.draw do
  get 'pokemons', to: 'pokemons#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'pokemons#index'

  get 'api/pokemons', to: 'api/pokemons#index'
  get 'api/pokemons/:id', to: 'api/pokemons#show'

  # マッチしないルートはフロントに流す
  get '*all', to: 'pokemons#index'
end
