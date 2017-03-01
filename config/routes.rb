Rails.application.routes.draw do
  devise_for :users, :path => 'users', :controllers => {:registrations => "registrations"}
  root to: "home#index"

	devise_scope :user do
    get '/inscription', to: 'users/registrations#new'
    post '/validation', to: 'users/registrations#create'
	end

end
