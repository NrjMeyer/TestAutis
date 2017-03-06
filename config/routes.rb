Rails.application.routes.draw do
  devise_for :users, :path => 'users', :controllers => {:registrations => "registrations"}
  root to: "home#index"

  devise_scope :user do
    get '/inscription', to: 'users/registrations#new'
    post '/inscription_payment', to: 'users/registrations#create'
    # get '/validation', to: 'users/registrations#new'    
    # post '/save_user', to: 'users/registrations#create'    
  end

end
