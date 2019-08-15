require 'date'
require './lib/cipher_cracker'
require './lib/cipher'

class Enigma
  def encrypt(message, key = key_generator, date = date_generator)
    cipher = Cipher.new
    cipher.encrypt(message, key, date)
  end

  def decrypt(ciphertext, key, date = date_generator)
    cipher = Cipher.new
    cipher.decrypt(ciphertext, key, date)
  end

  def key_generator
    key = rand(99_999).to_s
    times = 5 - key.length
    '0' * times + key
  end

  def date_generator
    Date.today.strftime('%d%m%y')
  end

  def crack(ciphertext, date = date_generator)
    cipher_cracker = CipherCracker.new
    shifts = cipher_cracker.crack_shifts(ciphertext)
    key = cipher_cracker.crack_keys(shifts, date)
    decrypt(ciphertext, key, date)
  end
end
