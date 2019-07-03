require './lib/enigma'
require './lib/cli'

class Decrypt
  include Cli

  def run
    decoded_msg = Enigma.new.decrypt(@input.read, @key, @date)
    @output.write(decoded_msg[:decryption])
    puts user_feedback(File.basename(@output), @key, @date)
    close
  end
end

decryptor = Decrypt.new
decryptor.cli(ARGV)
decryptor.run
