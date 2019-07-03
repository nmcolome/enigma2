require './lib/enigma.rb'

source = File.open(ARGV[0], 'r')
message = source.read
source.close

encryptor = Enigma.new.encrypt(message)

coded_msg = File.open(ARGV[1], 'w')
coded_msg.write(encryptor[:encryption])
coded_msg.close

puts "Created '#{ARGV[1]}' with the key #{encryptor[:key]} and date #{encryptor[:date]}"
