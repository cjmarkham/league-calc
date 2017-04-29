Rails.application.routes.draw do
  get '/', to: 'home#index'

  resources :teams, only: [:update]
  resources :fixtures, only: [:index, :show, :new, :create, :update] do
    collection do
      get 'weekly', to: 'weekly', as: :feed
    end
  end

  resources :leagues, only: [:index, :show] do
    member do
      get 'table', to: 'table'
    end
  end
end
