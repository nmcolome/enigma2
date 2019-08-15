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
    key = rand(99999).to_s
    times = 5 - key.length
    '0' * times + key
  end

  def date_generator
    Date.today.strftime('%d%m%y')
  end

  def crack(ciphertext, date = date_generator)
    cracker = CipherCracker.new
    shifts = cracker.crack_shifts(ciphertext)
    key = cracker.deconstruct_shift(shifts, date)
    decrypt(ciphertext, key, date)
  end
end
