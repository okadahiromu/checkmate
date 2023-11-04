Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'

  resources :lists
  resources :alert_emails, only: [:new, :create, :index]
end
