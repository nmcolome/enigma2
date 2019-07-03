class Enigma
  attr_reader :character_set

  def initialize
    @character_set = ('a'..'z').to_a << ' '
  end

  def encrypt(message, key = key_generator, date = date_generator)
    shifts = get_shifts(key, date)
    {
      encryption: code_msg(message, shifts).join(''),
      date: date,
      key: key
    }
  end

  def decrypt(ciphertext, key, date = date_generator)
    shifts = get_shifts(key, date)
    {
      decryption: decode_msg(ciphertext, shifts).join(''),
      date: date,
      key: key
    }
  end

  def get_keys(key)
    (0..3).to_a.map { |i| key[i..i + 1] }
  end

  def key_generator
    key = rand(99999).to_s
    times = 5 - key.length
    '0' * times + key
  end

  def date_generator
    Date.today.strftime('%d%m%y')
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

  def code_msg(text, shifts)
    text.split('').map do |e|
      start = @character_set.index(e)
      code = @character_set.rotate(start + shifts[0])[0]
      shifts.rotate!
      code
    end
  end

  def decode_msg(text, shifts)
    text.split('').map do |e|
      start = @character_set.index(e)
      code = @character_set.rotate(start - shifts[0])[0]
      shifts.rotate!
      code
    end
  end
end
