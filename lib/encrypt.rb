require './lib/enigma.rb'
require 'date'

class Encrypt
  def initialize(input, output)
    @input = File.open(input, 'r')
    @output = File.open(output, 'w')
  end

  def run
    coded_msg = Enigma.new.encrypt(@input.read)
    @output.write(coded_msg[:encryption])
    puts user_feedback(File.basename(@output), coded_msg)
    close
  end

  def close
    @input.close
    @output.close
  end

  def user_feedback(name, result)
    "Created '#{name}' with the key #{result[:key]} and date #{result[:date]}"
  end
end

Encrypt.new(ARGV[0], ARGV[1]).run
