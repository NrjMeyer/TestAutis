RailsAdmin.config do |config|

  # config.authorize_with do
  #   authenticate_or_request_with_http_basic('Login required') do |username, password|
  #     username == Rails.application.secrets.user &&
  #     password == Rails.application.secrets.password
  #   end
  # end

  # config.authorize_with do
  #   redirect_to main_app.root_path unless current_user.is_admin?
  # end


  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar true
  config.included_models = ["SideUser", "User", "Offer", "SlimpayPayment",
    "PaypalPayment", "Role", "Advantage"]

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new do
      except ["SideUser", "SlimpayPayment", "PaypalPayment"]
    end
    export
    bulk_delete do
      except ["SideUser", "SlimpayPayment", "PaypalPayment"]
    end
    show
    edit do
      except ["SideUser", "SlimpayPayment", "PaypalPayment"]
    end
    delete do
      except ["SideUser", "SlimpayPayment", "PaypalPayment"]
    end
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
