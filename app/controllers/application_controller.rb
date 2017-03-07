class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'inscription'

  def after_sign_in_path_for(resource)
    new_user_confirmation_path
  end

end
