class ApplicationController < ActionController::Base
<<<<<<< HEAD
  http_basic_authenticate_with :name => "vaincre",
                               :password => "lautisme"
  protect_from_forgery with: :exception
=======
  protect_from_forgery with: :null_session
>>>>>>> origin/merge
  layout 'inscription'
end
