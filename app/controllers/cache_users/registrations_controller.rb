class CacheUsers::RegistrationsController < Devise::RegistrationsController
  include Paypal
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    @cache_user = CacheUser.create(params.require(:cache_user).permit(:name, :surname,
      :phone_number, :address, :address_extend, :post_code, :city, :email, :password, :password_confirmation))

    payment_option = params[:payment_option]
    monthly = false

    if payment_option == "paypal" && monthly == false
      payment_data = Paypal.simplePayment(20)
      @cache_user.payment_id = payment_data['id']
    end

    @cache_user.save

    if @cache_user.new_record?
      puts @cache_user.errors
    else
      redirect_to payment_data['links'][1]['href']
    end
  end


  # GET /resource/edit
  # def edit
  #   super'
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :surname,
      :phone_number, :address, :address_extend, :post_code, :city, :payment_id])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(ressource)
  #   # puts(ressource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
