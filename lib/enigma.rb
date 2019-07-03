# require './lib/encrypt.rb'
# require './lib/decrypt.rb'
require './lib/transform'
require 'date'

class Enigma
  include Transform

  def encrypt(message, key = key_generator, date = date_generator)
    shifts = get_shifts(key, date)
    {
      encryption: transform_msg(message, shifts, 'code').join(''),
      key: key,
      date: date
    }
  end

  # def decrypt(ciphertext, key, date = date_generator)
  #   Decrypt.new.decode(ciphertext, key, date)
  # end

  def key_generator
    key = rand(99999).to_s
    times = 5 - key.length
    '0' * times + key
  end

  def date_generator
    Date.today.strftime('%d%m%y')
  end
end
