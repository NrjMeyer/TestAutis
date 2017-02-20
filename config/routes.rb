Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: "home#index"

	devise_scope :user do
		get 'inscription', to: 'devise/registrations#new'
	end
	
end
