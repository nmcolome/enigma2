require './lib/enigma'
require './lib/cli'

class Crack
  include Cli

  def cli(args)
    @input = File.open(args[0], 'r')
    @output = File.open(args[1], 'w')
    @date = args[2]
  end

  def run
    cracked_msg = Enigma.new.crack(@input.read, @date)
    @output.write(cracked_msg[:decryption])
    puts user_feedback(File.basename(@output), cracked_msg[:key], cracked_msg[:date])
    close
  end
end

cracked = Crack.new
cracked.cli(ARGV)
cracked.run
