Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :path => 'users', :controllers => {:registrations => "registrations", confirmations: 'confirmations'}
  root to: "home#index"

  get '/inscription', to: 'cache_users#new'
  get '/recu', to: 'recu#index'
  get '/recu/show', to: 'recu#show'
  post '/inscription_payment', to: 'cache_users#create'

  devise_scope :user do
    get '/validation', to: 'users/registrations#new'
    get '/execute_payment', to: 'users/registrations#payment'
  end

end
