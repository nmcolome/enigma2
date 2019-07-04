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

  def crack(ciphertext, date = date_generator)
    ending = ciphertext[-4..-1]
    comparator = ' end'
    shifts = []
    (0..3).to_a.each do |i|
      coded = character_set.index(ending[i])
      regular = character_set.index(comparator[i])
      shifts << (coded - regular + 27)
    end
    rotation_size = ciphertext.length % 4
    shifts.rotate!(4 - rotation_size)
    key = deconstruct_shift(shifts, date)
    decrypt(ciphertext, key, date)
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

  def deconstruct_shift(shifts, date)
    offsets = get_offsets(date)
    keys = (0..3).to_a.map { |i| shifts[i] - offsets[i].to_i }
    valid = []
    (0..2).to_a.each do |i|
      valid.push(keys[i], keys[i+1]) if keys[i] % 10 == keys[i+1] / 10
    end

    until valid.count == 4
      last = keys.index(valid[0])

      until keys[last-1] % 10 == keys[last] / 10 || keys[last-1] < 0
        keys[last-1] -= 27
      end

      if keys[last-1] < 0
        until keys[last-1] % 10 == keys[last] / 10
          keys[last-1] += 27
        end
        valid.unshift(keys[last-1])
      else
        valid.unshift(keys[last-1])
      end
    end

    key = []
    valid.each { |keys| key << keys / 10 }
    key << valid[-1] % 10
    key.join('')
  end
end
