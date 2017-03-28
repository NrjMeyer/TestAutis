RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar true
  config.included_models = ["SideUser", "User", "Offer", "SlimpayPayment",
    "PaypalPayment", "Role", "Advantages"]

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
