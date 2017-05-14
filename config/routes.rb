Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :path => 'users', :controllers => {:registrations => "registrations", confirmations: 'confirmations'}
  root to: "home#index"

  get '/test', to: 'home#test'
  get '/erreur', to: 'cache_users#error'
  get '/inscription', to: 'cache_users#new'
  get '/annulation', to: 'cache_users#cancel'
  post '/inscription_payment', to: 'cache_users#create'

  get '/cb', to: 'cache_users#payment'

  devise_scope :user do
    # CB payment route
    post '/cb_validation', to: 'users/registrations#new_cb'
  
    get '/validation', to: 'users/registrations#new'
    get '/execute_payment', to: 'users/registrations#payment'
  end

end
