require 'date'
require 'pry'

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
    crack_keys(keys)
  end

  def crack_keys(keys)
    valid = build_matching_keys(keys)
    key = valid.map { |e| e / 10 }
    key << valid[-1] % 10
    key.join('')
  end

  def get_valid_keys(keys)
    valid = []
    (0..3).to_a.each do |i|
      valid.push(keys[i], keys[i + 1]) if i < 3 && keys[i] % 10 == keys[i + 1] / 10
      valid.push(keys[i - 1], keys[i]) if i > 0 && keys[i - 1] % 10 == keys[i] / 10
    end
    valid.uniq
  end

  def check_larger_keys(keys, i, next_i, direction)
    if direction == 'right'
      keys[next_i] += 27 until keys[i] % 10 == keys[next_i] / 10 || keys[next_i] > 99
    elsif direction == 'left'
      keys[next_i] += 27 until keys[next_i] % 10 == keys[i] / 10 || keys[next_i] > 99
    end
  end

  def key_builder(valid, keys)
    until valid.count == 4
      direction = keys[0, valid.length] == valid ? 'right' : 'left'
      valid_key_i = valid_index(valid, keys)
      next_i = direction == 'right' ? valid_key_i + 1 : valid_key_i - 1
      check_larger_keys(keys, valid_key_i, next_i, direction)
      direction == 'right' ? valid.push(keys[next_i]) : valid.unshift(keys[next_i])
    end
    valid
  end

  def valid_index(valid, keys)
    if keys[0, valid.length] == valid
      valid.length - 1
    elsif keys[-valid.length, valid.length] == valid
      keys.length - valid.length
    else
      keys.index(valid[0])
    end
  end

  def build_key_options(keys)
    keys.map do |key|
      (0..3).to_a.map { |i| key + 27 * i }
    end
  end

  def get_valid_key_options(keys)
    options = build_key_options(keys)
    (0..2).to_a.map do |i|
      result = []
      options[i].each do |key|
        options[i + 1].each do |next_key|
          result << [key, next_key] if key % 10 == next_key / 10
        end
      end
      [[i, i + 1], result]
    end
  end

  def option_builder(matching, keys)
    positions = (0..3).to_a
    matching.each do |key, value|
      complement = positions - key
      value.each do |pair|
        complement.each { |i| pair.insert(i, keys[i]) }
      end
    end
    matching.values.flatten(1)
  end

  def build_matching_keys(keys)
    keys.map! { |k| k % 27 }
    matches = get_valid_key_options(keys).to_h.values.flatten(1)
    options = option_builder(get_valid_key_options(keys).to_h, keys)
    valid = (0..matches.count - 1).to_a.map do |i|
      key_builder(matches[i], options[i])
    end
    valid.uniq.select { |valid_keys| valid_keys.all? { |e| e < 100 } }.sample
  end
end
