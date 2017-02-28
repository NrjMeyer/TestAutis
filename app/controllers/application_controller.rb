class ApplicationController < ActionController::Base
  http_basic_authenticate_with :name => "vaincre",
                               :password => "lautisme"
  protect_from_forgery with: :exception
  layout 'inscription'
end
