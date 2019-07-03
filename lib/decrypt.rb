require './lib/enigma.rb'
require 'date'

class Decrypt
  def initialize(input, output, key, date)
    @input = File.open(input, 'r')
    @output = File.open(output, 'w')
    @key = key
    @date = date
  end

  def run
    decoded_msg = Enigma.new.decrypt(@input.read, @key, @date)
    @output.write(decoded_msg[:decryption])
    puts user_feedback(File.basename(@output))
    close
  end

  def close
    @input.close
    @output.close
  end

  def user_feedback(name)
    "Created '#{name}' with the key #{@key} and date #{@date}"
  end
end

Decrypt.new(ARGV[0], ARGV[1], ARGV[2], ARGV[3]).run
