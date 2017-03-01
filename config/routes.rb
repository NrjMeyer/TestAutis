Rails.application.routes.draw do
  devise_for :cache_users, :path => 'cache_users', :controllers => {:registrations => "registrations"}
  root to: "home#index"

	devise_scope :cache_user do
    get '/inscription', to: 'cache_users/registrations#new'
    post '/validation', to: 'cache_users/registrations#create'
	end

end
