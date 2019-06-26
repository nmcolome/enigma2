class Enigma
  attr_reader :character_set

  def initialize
    @character_set = ('a'..'z').to_a << ' '
  end

  def encrypt(message, key, date)
    shifts = get_shifts(key, date)
    msg = message.split('')
    coded_msg = msg.map do |e|
      start = @character_set.index(e)
      code = @character_set.rotate(start + shifts[0])[0]
      shifts.rotate!
      code
    end
    {
      encryption: coded_msg.join(''),
      date: date,
      key: key
    }
  end

  def get_keys(key)
    (0..3).to_a.map { |i| key[i..i+1]}
  end

  def get_offsets(date)
    square_date = date.to_i ** 2
    square_date.to_s[-4..-1].split('')
  end

  def get_shifts(key, date)
    offsets = get_offsets(date)
    keys = get_keys(key)
    shifts = (0..3).to_a.map { |i| offsets[i].to_i + keys[i].to_i }
    shifts.map { |shift| shift % 27 }
  end
end
