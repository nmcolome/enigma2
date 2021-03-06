class Cipher
  attr_reader :character_set

  def initialize
    @character_set = ('a'..'z').to_a << ' '
  end

  def encrypt(message, key, date)
    shifts = get_shifts(key, date)
    {
      encryption: transform_msg(message, shifts, 'code').join(''),
      key: key,
      date: date
    }
  end

  def decrypt(ciphertext, key, date)
    shifts = get_shifts(key, date)
    {
      decryption: transform_msg(ciphertext, shifts, 'decode').join(''),
      key: key,
      date: date
    }
  end

  def get_keys(key)
    (0..3).to_a.map { |i| key[i..i + 1] }
  end

  def get_offsets(date)
    square_date = date.to_i**2
    square_date.to_s[-4..-1].split('')
  end

  def get_shifts(key, date)
    offsets = get_offsets(date)
    keys = get_keys(key)
    shifts = (0..3).to_a.map { |i| offsets[i].to_i + keys[i].to_i }
    shifts.map { |shift| shift % 27 }
  end

  def transform_msg(text, shifts, type)
    text.downcase.split('').map do |e|
      start = character_set.index(e)
      character_lookup(e, start, shifts, type)
    end
  end

  def character_lookup(element, start, shifts, type)
    if start.nil?
      element
    else
      transform = letter_rotation(start, shifts[0], type)
      shifts.rotate!
      transform
    end
  end

  def letter_rotation(start, shift, type)
    if type == 'code'
      character_set.rotate(start + shift)[0]
    else
      character_set.rotate(start - shift)[0]
    end
  end
end
