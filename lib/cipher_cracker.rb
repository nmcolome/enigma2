class CipherCracker
  attr_reader :character_set

  def initialize
    @character_set = ('a'..'z').to_a << ' '
  end

  def get_offsets(date)
    square_date = date.to_i**2
    square_date.to_s[-4..-1].split('')
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

  def build_matching_keys(keys)
    keys.map! { |k| k % 27 }
    matches = get_valid_key_options(keys).to_h.values.flatten(1)
    options = option_builder(get_valid_key_options(keys).to_h, keys)
    valid = (0..matches.count - 1).to_a.map do |i|
      key_builder(matches[i], options[i])
    end
    valid.uniq.select { |valid_keys| valid_keys.all? { |e| e < 100 } }.sample
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

  def build_key_options(keys)
    keys.map do |key|
      (0..3).to_a.map { |i| key + 27 * i }
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

  def check_larger_keys(keys, i, next_i, direction)
    if direction == 'right'
      keys[next_i] += 27 until keys[i] % 10 == keys[next_i] / 10 || keys[next_i] > 99
    elsif direction == 'left'
      keys[next_i] += 27 until keys[next_i] % 10 == keys[i] / 10 || keys[next_i] > 99
    end
  end
end
