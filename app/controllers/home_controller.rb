class HomeController < ApplicationController
  def index
    redirect_to inscription_path
  end

  def dons
  end

  def test
    mg_client = Mailgun::Client.new "key-6ed71e42f2d66d7283c17ce77adf28f3"

    message_params =  { from: 'bob@vaincrelautisme.org',
      to:   'martinziserman@gmail.com',
      subject: 'The Ruby SDK is awesome!',
      text:    'It is really easy to send a message!'
    }

    # Send your message through the client
    mg_client.send_message('http://mg.vaincrelautisme.org', message_params)
  end
end
