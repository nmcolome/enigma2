require './lib/transform.rb'

class Encrypt
  include Transform

  def code(message, key, date)
    shifts = get_shifts(key, date)
    {
      encryption: transform_msg(message, shifts, 'code').join(''),
      key: key,
      date: date
    }
  end
end
