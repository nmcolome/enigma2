require 'date'

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
    valid = build_matching_keys(keys)
    key = valid.map { |e| e / 10 }
    key << valid[-1] % 10
    key.join('')
  end

  def get_first_matching_keys(keys)
    valid = []
    (0..2).to_a.each do |i|
      valid.push(keys[i], keys[i + 1]) if keys[i] % 10 == keys[i + 1] / 10
    end
    valid.uniq
  end

  def check_smaller_keys(keys, index, next_index, direction)
    if direction == 'right'
      keys[next_index] -= 27 until keys[index] % 10 == keys[next_index] / 10 || keys[next_index] < 0
    elsif direction == 'left'
      keys[next_index] -= 27 until keys[next_index] % 10 == keys[index] / 10 || keys[next_index] < 0
    end
  end

  def check_larger_keys(keys, index, next_index, direction)
    if direction == 'right'
      keys[next_index] += 27 until keys[index] % 10 == keys[next_index] / 10 || keys[next_index] > 99
    elsif direction == 'left'
      keys[next_index] += 27 until keys[next_index] % 10 == keys[index] / 10 || keys[next_index] > 99
    end
  end

  def build_matching_keys(keys)
    valid = []
    keys.map! { |k| k % 27 }
    valid = get_first_matching_keys(keys)

    i = 0
    while valid.empty?
      if keys[i] > 99
        keys[i] -= 27
        i += 1
      else
        keys[i] += 27
      end
      valid = get_first_matching_keys(keys)
    end

    until valid.count == 4
      direction = keys.index(valid[0]) == 0 ? 'right' : 'left'
      valid_key_index = direction == 'right' ? keys.index(valid[-1]) : keys.index(valid[0])
      next_index = direction == 'right' ? valid_key_index + 1 : valid_key_index - 1
      check_smaller_keys(keys, valid_key_index, next_index, direction)
      check_larger_keys(keys, valid_key_index, next_index, direction) if keys[next_index] < 0
      direction == 'right' ? valid.push(keys[next_index]) : valid.unshift(keys[next_index])
    end
    valid
  end
end
