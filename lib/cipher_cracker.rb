class CipherCracker
  def character_set
    ('a'..'z').to_a << ' '
  end

  def crack_shifts(ciphertext)
    ending = ciphertext[-4..-1]
    shifts = crack_rotations(ending)
    abcd_remainder = ciphertext.length % 4
    shifts.rotate!(4 - abcd_remainder)
  end

  def crack_rotations(ending)
    (0..3).to_a.map do |i|
      coded = character_set.index(ending[i])
      regular = character_set.index(' end'[i])
      coded - regular + 27
    end
  end

  def get_offsets(date)
    square_date = date.to_i**2
    square_date.to_s[-4..-1].split('')
  end

  def crack_keys(shifts, date)
    offsets = get_offsets(date)
    initial_keys = (0..3).to_a.map { |i| shifts[i] - offsets[i].to_i }
    initial_keys.map! { |k| k % 27 }
    abcd = get_keys(initial_keys)
    turn_to_text(abcd)
  end

  def turn_to_text(keys)
    key = keys.map { |e| e / 10 }
    key << keys[-1] % 10
    key.join('')
  end

  def get_keys(keys)
    valid = get_valid_key_options(keys)
    valid.uniq.select { |valid_keys| valid_keys.all? { |e| e < 100 } }.sample
  end

  def get_valid_key_options(keys)
    options = possible_keys(keys)
    a_b = get_matches(options[0], options[1])
    c_d = get_matches(options[2], options[3])
    get_valid_keys(a_b, c_d)
  end

  def possible_keys(keys)
    keys.map do |key|
      (0..3).to_a.map { |i| key + 27 * i }
    end
  end

  def get_matches(keys, next_keys)
    result = []
    keys.each do |key|
      next_keys.each do |next_key|
        result << [key, next_key] if key % 10 == next_key / 10
      end
    end
    result
  end

  def get_valid_keys(a_b, c_d)
    valid = []
    a_b.each do |pair|
      c_d.each do |next_pair|
        valid << [pair, next_pair].flatten if pair[1] % 10 == next_pair[0] / 10
      end
    end
    valid
  end
end
