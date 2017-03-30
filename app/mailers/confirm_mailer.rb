class ConfirmMailer < ApplicationMailer
  default from: 'donateur@vaincrelautisme.org'

  def success_subscription(user)
    @user = user
    mail(to: @user.email, subject: 'Un immense merci pour votre adhésion !')
  end

end
