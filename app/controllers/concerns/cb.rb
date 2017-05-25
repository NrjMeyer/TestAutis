require 'open3'

module Cb
  extend ActiveSupport::Concern

  def self.request(amount, type, id)

    file = File.join(Rails.root, 'bin')

    param = "merchant_id=014213245611111"
    param = "#{param} merchant_country=fr"
    param = "#{param} amount=#{amount}" 
    param = "#{param} currency_code=978"
    param = "#{param} data=#{amount}|#{type}|#{id}"
    param = "#{param} pathfile='#{file}/cb_payment/param/pathfile'"
    param = "#{param} normal_return_url="+Settings.cb.callback_url_success
    param = "#{param} cancel_return_url="+Settings.cb.callback_url_failure
    param = "#{param} automatic_response_url="+Settings.cb.automatic_response_url

    pathfile = "#{file}/cb_payment/request"

    cmd = pathfile + " " + param

    stdin, stdout, stderr = Open3.popen3(cmd)

    puts '----------------------'
    puts stdout
    puts '----------------------'

    result = stdout.read[4..-1]
    return result.tr('!','')

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

  def self.autoresponse(data)
    file = File.join(Rails.root, 'bin')

    message = "message=#{data}"

    pathfile = "pathfile='#{file}/cb_payment/param/pathfile'"

    pathbin = "#{file}/cb_payment/response"

    logpath = "#{Rails.root}/cb.txt"

    cmd = "#{pathbin} #{pathfile} #{message}"

    stdin, stdout, stderr = Open3.popen3(cmd)
    out = stdout.read
    result = out.split('!')

    if result[1] != 0
        File.write(logpath, "API call error.\n")
        File.write(logpath, "Error message: #{result[2]}.\n")
    else
        File.write(logpath, "merchant_id : #{result[3]}\n");
        File.write(logpath, "merchant_country : #{result[4]}\n");
        File.write(logpath, "amount : #{result[5]}\n");
        File.write(logpath, "transaction_id : #{result[6]}\n");
        File.write(logpath, "transmission_date: #{result[7]}\n");
        File.write(logpath, "payment_means: #{result[8]}\n");
        File.write(logpath, "payment_time : #{result[9]}\n");
        File.write(logpath, "payment_date : #{result[10]}\n");
        File.write(logpath, "response_code : #{result[11]}\n");
        File.write(logpath, "payment_certificate : #{result[12]}\n");
        File.write(logpath, "authorisation_id : #{result[13]}\n");
        File.write(logpath, "currency_code : #{result[14]}\n");
        File.write(logpath, "card_number : #{result[15]}\n");
        File.write(logpath, "cvv_flag: #{result[16]}\n");
        File.write(logpath, "cvv_response_code: #{result[17]}\n");
        File.write(logpath, "bank_response_code: #{result[18]}\n");
        File.write(logpath, "complementary_code: #{result[19]}\n");
        File.write(logpath, "complementary_info: #{result[20]}\n");
        File.write(logpath, "return_context: #{result[21]}\n");
        File.write(logpath, "caddie : #{result[22]}\n");
        File.write(logpath, "receipt_complement: #{result[23]}\n");
        File.write(logpath, "merchant_language: #{result[24]}\n");
        File.write(logpath, "language: #{result[25]}\n");
        File.write(logpath, "customer_id: #{result[26]}\n");
        File.write(logpath, "order_id: #{result[27]}\n");
        File.write(logpath, "customer_email: #{result[28]}\n");
        File.write(logpath, "customer_ip_address: #{result[29]}\n");
        File.write(logpath, "capture_day: #{result[30]}\n");
        File.write(logpath, "capture_mode: #{result[31]}\n");
        File.write(logpath, "data: #{result[32]}\n");
        File.write(logpath, "order_validity: #{result[33]}\n");
        File.write(logpath, "transaction_condition: #{result[34]}\n");
        File.write(logpath, "statement_reference: #{result[35]}\n");
        File.write(logpath, "card_validity: #{result[36]}\n");
        File.write(logpath, "card_validity: #{result[37]}\n");
        File.write(logpath, "card_validity: #{result[38]}\n");
        File.write(logpath, "card_validity: #{result[39]}\n");
        File.write(logpath, "card_validity: #{result[40]}\n");
        File.write(logpath, "card_validity: #{result[41]}\n");
        File.write(logpath, "-------------------------------------------\n");
    end

    return result
  end

end