class Enigma
  def encrypt(message, key = key_generator, date = date_generator)
    shifts = get_shifts(key, date)
    {
      encryption: transform_msg(message, shifts, 'code').join(''),
      key: key,
      date: date
    }
  end

  def decrypt(ciphertext, key, date = date_generator)
    shifts = get_shifts(key, date)
    {
      decryption: transform_msg(ciphertext, shifts, 'decode').join(''),
      key: key,
      date: date
    }
  end

  def key_generator
    key = rand(99999).to_s
    times = 5 - key.length
    '0' * times + key
  end

  def date_generator
    Date.today.strftime('%d%m%y')
  end

  def character_set
    ('a'..'z').to_a << ' '
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
    text.split('').map do |e|
      start = character_set.index(e)
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

  def crack(ciphertext, date = date_generator)
    shifts = crack_shifts(ciphertext)
    key = deconstruct_shift(shifts, date)
    decrypt(ciphertext, key, date)
  end

  def crack_shifts(ciphertext)
    ending = ciphertext[-4..-1]
    shifts = crack_rotations(ending)
    rotation_size = ciphertext.length % 4
    shifts.rotate!(4 - rotation_size)
  end

  def crack_rotations(ending)
    (0..3).to_a.map do |i|
      coded = character_set.index(ending[i])
      regular = character_set.index(' end'[i])
      coded - regular + 27
    end
  end

  def deconstruct_shift(shifts, date)
    offsets = get_offsets(date)
    keys = (0..3).to_a.map { |i| shifts[i] - offsets[i].to_i }
    build_valid(keys)
  end

  def build_valid(keys)
    valid = get_first_matching_keys(keys)
    build_matching_keys(keys, valid)
    key = valid.map { |e| e / 10 }
    key << valid[-1] % 10
    key.join('')
  end

  def get_first_matching_keys(keys)
    valid = []
    (0..2).to_a.each do |i|
      valid.push(keys[i], keys[i + 1]) if keys[i] % 10 == keys[i + 1] / 10
    end
    valid
  end

  def check_smaller_keys(keys, index)
    until keys[index - 1] % 10 == keys[index] / 10 || keys[index - 1] < 0
      keys[index - 1] -= 27
    end
  end

  def check_larger_keys(keys, index)
    keys[index - 1] += 27 until keys[index - 1] % 10 == keys[index] / 10
  end

  def build_matching_keys(keys, valid)
    until valid.count == 4
      first_valid = keys.index(valid[0])
      check_smaller_keys(keys, first_valid)
      check_larger_keys(keys, first_valid) if keys[first_valid - 1] < 0
      valid.unshift(keys[first_valid - 1])
    end
  end
end
