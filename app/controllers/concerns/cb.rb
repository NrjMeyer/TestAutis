require 'open3'

module Cb
  extend ActiveSupport::Concern

  def self.request(amount)

    file = File.join(Rails.root, 'bin')

    param = "merchant_id=014213245611111"
    param = "#{param} merchant_country=fr"
    param = "#{param} amount=#{amount}" 
    param = "#{param} currency_code=978"
    param = "#{param} pathfile='#{file}/cb_payment/param/pathfile'"
    param = "#{param} normal_return_url="+Settings.cb.callback_url_success
    param = "#{param} cancel_return_url="+Settings.cb.callback_url_failure

    puts '---------------------'
    puts file
    puts '---------------------'

    pathfile = "#{file}/cb_payment/request"

    cmd = pathfile + " " + param

    stdin, stdout, stderr = Open3.popen3(cmd)
    result = stdout.read[4..-1]
    return  result.tr('!','')

  end

  def self.response(data)

    file = File.join(Rails.root, 'bin')

    message = "message=#{data}"

    pathfile = "pathfile='#{file}/cb_payment/param/pathfile'"

    pathbin = "#{file}/cb_payment/response"

    cmd = "#{pathbin} #{pathfile} #{message}"

    stdin, stdout, stderr = Open3.popen3(cmd)
    out = stdout.read
    return result = out.split('!')
  end

end