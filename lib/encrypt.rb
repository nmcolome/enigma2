require './lib/enigma.rb'
require './lib/cli'

class Encrypt
  include Cli

  def run
    coded = Enigma.new.encrypt(@input.read)
    @output.write(coded[:encryption])
    puts user_feedback(File.basename(@output), coded[:key], coded[:date])
    close
  end
end

encryptor = Encrypt.new
encryptor.cli(ARGV)
encryptor.run
