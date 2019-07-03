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
    puts "Created '#{File.basename(@output)}' with the key #{coded_msg[:key]} and date #{coded_msg[:date]}"
    close
  end

  def close
    @input.close
    @output.close
  end
end

Encrypt.new(ARGV[0], ARGV[1]).run
