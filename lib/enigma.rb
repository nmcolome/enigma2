class Enigma
  def encrypt(message, key, date)
    msg = message.split('')
    square_date = date.to_i ** 2
    offsets = square_date.to_s[-4..-1].split('')
    keys = (0..3).to_a.map { |i| key[i..i+1]}

  end

  def character_set
    ('a'..'z').to_a << ' '
  end
end