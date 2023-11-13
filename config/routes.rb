Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'

  resources :lists do
    resources :items
  end
  resources :alert_emails, only: [:new, :create, :index]
end
