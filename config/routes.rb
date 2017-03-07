Rails.application.routes.draw do
  devise_for :users, :path => 'users', :controllers => {:registrations => "registrations"}
  root to: "home#index"

  get '/inscription', to: 'cache_users#new'
  post '/inscription_payment', to: 'cache_users#create'

  devise_scope :user do
    get '/validation', to: 'users/registrations#new'    
    post '/save_user', to: 'users/registrations#create'    
  end

end