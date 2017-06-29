Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  devise_scope :user do
    get 'confirm', to: 'users/confirmations#new', as: :confirm
    
    unauthenticated :user do
      root :to => 'users/sessions#new', as: :unauthenticated_root
    end

    authenticated :user do
      root :to => 'submissions#index', as: :authenticated_root
    end
  end

  resources :submissions
end
