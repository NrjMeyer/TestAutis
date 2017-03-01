class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'inscription'

  def after_sign_up_user_path(ressources)
    current_user_path
  end

end
