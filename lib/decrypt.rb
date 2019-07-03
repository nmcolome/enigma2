require './lib/transform.rb'

class Decrypt
  include Transform

  def decode(ciphertext, key, date)
    shifts = get_shifts(key, date)
    {
      decryption: transform_msg(ciphertext, shifts, 'decode').join(''),
      key: key,
      date: date
    }
  end
end
