require './lib/encrypt.rb'
require './lib/decrypt.rb'

class Enigma
  def encrypt(message, key = key_generator, date = date_generator)
    encryptor = Encrypt.new
    encryptor.code(message, key, date)
  end

  def decrypt(ciphertext, key, date = date_generator)
    decryptor = Decrypt.new
    decryptor.decode(ciphertext, key, date)
  end

  def key_generator
    key = rand(99999).to_s
    times = 5 - key.length
    '0' * times + key
  end

  def date_generator
    Date.today.strftime('%d%m%y')
  end

  # def transform_msg(text, shifts, type)
  #   text.split('').map do |e|
  #     start = @character_set.index(e)
  #     transform = letter_rotation(start, shifts[0], type)
  #     shifts.rotate!
  #     transform
  #   end
  # end

  # def letter_rotation(start, shift, type)
  #   if type == 'code'
  #     @character_set.rotate(start + shift)[0]
  #   else
  #     @character_set.rotate(start - shift)[0]
  #   end
  # end
end
