Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :path => 'users', :controllers => {:registrations => "registrations", confirmations: 'confirmations'}
  root to: "home#index"

  get '/inscription', to: 'cache_users#new'
  post '/inscription_payment', to: 'cache_users#create'

  devise_scope :user do
    get '/validation', to: 'users/registrations#new'
    get '/execute_payment', to: 'users/registrations#payment'
  end

end
