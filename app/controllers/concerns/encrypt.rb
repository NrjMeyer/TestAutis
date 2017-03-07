module Encrypt
  extend ActiveSupport::Concern

  def self.encryption(msg)
    begin
      cipher = OpenSSL::Cipher.new(Settings.encrypt.algorithme)
      cipher.encrypt()
      cipher.key = Settings.encrypt.key
      crypt = cipher.update(msg) + cipher.final()
      crypt_string = (Base64.encode64(crypt))
      return crypt_string
    rescue Exception => exc
      puts ("Message for the encryption log file for message #{msg} = #{exc.message}")
    end
  end

  def self.decryption(msg)
    begin
      cipher = OpenSSL::Cipher.new(Settings.encrypt.algorithme)
      cipher.decrypt()
      cipher.key = Settings.encrypt.key
      tempkey = Base64.decode64(msg)
      crypt = cipher.update(tempkey)
      crypt << cipher.final()
      return crypt
    rescue Exception => exc
      puts ("Message for the decryption log file for message #{msg} = #{exc.message}")
    end
  end
end