require './lib/encrypt.rb'
require './lib/decrypt.rb'

class Enigma
  def encrypt(message, key = key_generator, date = date_generator)
    Encrypt.new.code(message, key, date)
  end

  def decrypt(ciphertext, key, date = date_generator)
    Decrypt.new.decode(ciphertext, key, date)
  end

  def key_generator
    key = rand(99999).to_s
    times = 5 - key.length
    '0' * times + key
  end

  def date_generator
    Date.today.strftime('%d%m%y')
  end
end
