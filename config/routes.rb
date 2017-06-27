Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    get 'login', to: 'devise/sessions#new', as: :login

    unauthenticated :user do
      root :to => 'devise/sessions#new', as: :unauthenticated_root
    end

    authenticated :user do
      root :to => 'submissions#index', as: :authenticated_root
    end
  end

  resources :submissions
end
