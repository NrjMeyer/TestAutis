Rails.application.routes.draw do
  devise_for :cache_users, :path => 'cache_users', :controllers => {:registrations => "registrations"}
  devise_for :users, :path => 'users', :controllers => {:registrations => "registrations"}
  root to: "home#index"

	devise_scope :cache_user do
    get '/inscription', to: 'cache_users/registrations#new'
    post '/cache_user', to: 'cache_users/registrations#create'
	end

  devise_scope :user do
    get '/validation', to: 'users/registrations#new'    
    post '/users', to: 'registrations#create'    
  end

end
