class Users::RegistrationsController < Devise::RegistrationsController
  include Paypal
  before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  def create
    @user = User.create(params.require(:user).permit(:name, :surname,
      :phone_number, :address, :address_extend, :post_code, :city, :email, :password, :password_confirmation))

    payment_option = params[:payment_option]
    monthly = false

    if payment_option == "paypal" && monthly == false
      payment_data = Paypal.simplePayment(20)
      @user.payment_id = payment_data['id']
    end

    if @user.save
      puts payment_data
      redirect_to payment_data['links'][1]['href']
    else
      puts @user.errors.inspect
    end
  end

  # def new
  #   # super
  #   if CacheUser.find_by(payment_id: params[:paymentId]) != nil
  #     @cache_user = CacheUser.find_by(payment_id: params[:paymentId])
  #     # @user = User.create(
  #     #   email: @cache_user.email,
  #     #   encrypted_password: @cache_user.encrypted_password,
  #     #   name: @cache_user.name,
  #     #   surname: @cache_user.surname,
  #     #   phone_number: @cache_user.phone_number,
  #     #   address: @cache_user.address,
  #     #   address_extend: @cache_user.address_extend,
  #     #   post_code: @cache_user.post_code,
  #     #   city: @cache_user.city,
  #     #   tax_receipt: @cache_user.tax_receipt,
  #     #   sub_newsletter: @cache_user.sub_newsletter,
  #     #   payment_id: params[:payer_id],
  #     #   )
  #     @user = User.new
  #     @user.email = @cache_user.email
  #     @user.email = @cache_user.encrypted_password

  #     puts @user.inspect
  #     puts @cache_user.inspect
  #     if @user.save
  #       payment = HTTParty.post('https://api.sandbox.paypal.com/v1/payments/payment/'+ params[:payment_id] +'/execute', 
  #         headers: {
  #             'Content-Type' => 'application/json',
  #             'Authorization' => params[:token],
  #           },
  #         body: {
  #             :payer_id => params[:payer_id]
  #           }.to_json
  #           )
  #       puts payment
  #     else
  #       puts @user.errors.inspect
  #     end
  #     # redirect_to save_users_path, :payment_method => 'paypal',
  #     #                              :payment_id => params[:paymentId],
  #     #                              :token => params[:token], 
  #     #                              :payer_id => params[:PayerId]
  #   end
  # end

  # # POST /resource
  # def create
  #   puts params.inspect
  #   if params[:payment_method] == 'paypal'
  #     @cache_user = CacheUser.find_by(payment_id: params[:payment_id])
  #     @user = User.create(
  #       email: @cache_user.email,
  #       encrypted_password: @cache_user.encrypted_password,
  #       name: @cache_user.name,
  #       surname: @cache_user.surname,
  #       phone_number: @cache_user.phone_number,
  #       address: @cache_user.address,
  #       address_extend: @cache_user.address_extend,
  #       post_code: @cache_user.post_code,
  #       city: @cache_user.city,
  #       tax_receipt: @cache_user.tax_receipt,
  #       sub_newsletter: @cache_user.sub_newsletter,
  #       payment_id: params[:payer_id],
  #       )

  #     if @user.valid?
  #       payment = HTTParty.post('https://api.sandbox.paypal.com/v1/payments/payment/'+ params[:payment_id] +'/execute', 
  #         headers: {
  #             'Content-Type' => 'application/json',
  #             'Authorization' => params[:token],
  #           },
  #         body: {
  #             :payer_id => params[:payer_id]
  #           }.to_json
  #           )
  #       puts payment
  #     else
  #       puts @cache_user.errors.inspect      
  #     end

  #   end
  #   redirect_to root_path
  # end

  # GET /resource/edit
  # def edit
  #   super
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

  # protected

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
  # def after_sign_up_path_for(resource)
  #   redirect_to new_user_session_path
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
