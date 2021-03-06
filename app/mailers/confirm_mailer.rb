class ConfirmMailer < ApplicationMailer
  default from: 'dons-adhesions@vaincrelautisme.org'

  def success_subscription(user, path = nil, pdf = false, don = false)
    @pdf_url = path
    @pdf = pdf
    @don = don
    @user = user
    if don == true
      mail(to: @user.email, subject: 'Un immense merci pour votre don !')
    else
      mail(to: @user.email, subject: 'Un immense merci pour votre adhésion !')
    end
  end

end
