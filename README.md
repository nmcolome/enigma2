# Enigma

Enigma is a tool for encrypting, decrypting and cracking a message using an encryption algorithm (detailed below). Additionally, it has a command line interface to code, decode or crack files.

This tool uses the standard lowercase alphabet (a-z), plus a space (' ') as a character set. Anything outside this set (like symbols, numbers or escape characters) will not be transformed.

## Encryption Algorithm
The encryption is based on the [Caesar Cipher](https://en.wikipedia.org/wiki/Caesar_cipher). The idea is that we can transform a message by shifting each element an 'x' amount of places.

This particular algorithm uses 4 different shifts known as A, B, C and D. Shift A will move the 1st, 5th, 9th... letter or space of the message, shift B will determine the new letters for the 2nd, 6th, 10th..., shift C the 3rd, 7th, 11th... and shift D will determine the 4th, 8th, 12th... etc.

To calculate each shift, we will sum Keys and Offsets.

Keys are a random five digit number, like 01023, splitting them like `[A:01, B:10, C:02, D:23]` for ABCD.

Offests are calculated using the date of transmission. With the date formatted as DDMMYY, square it and take the last 4 digits. For example, for the date October 30th, 2019, formatted as 301019, squaring it (90612438361) and the final offsets are `[A:8, B:3, C:6, D:1]`

Using the date and a random key we build the shifts. In this case, the shifts will be `[A:09, B:13, C:08, D:24]`

## Cracking
In order to crack a message we use just the date of transmission and we make the assumption the each message ends with the characters `' end'`; with this we can calculate the keys and decode it.

## How to install it

1. [Install Ruby](https://www.ruby-lang.org/en/documentation/installation/) in your machine.
2. [Clone](https://help.github.com/en/articles/cloning-a-repository) this repo 
3. Once you have your local clone, enter the following in your terminal:
```
$ cd enigma2
$ bundle install
```

## How to use it

The `Enigma` class provides the following:

`Enigma#encrypt(message, key, date)`

| Argument | Description | Requirement |
| ----- | ----- |-----|
| Message | The string to be encoded (symbols, numbers and escape characters will not be transformed) | Required |
| Key | 5 digit random number | Optional |
| Date | DDMMYY format | Optional |

`Enigma#decrypt(ciphertext, key, date)`

| Argument | Description | Requirement |
| ----- | ----- |-----|
| Ciphertext | The string to be decoded (symbols, numbers and escape characters will not be transformed) | Required |
| Key | 5 digit random number | Required |
| Date | DDMMYY format | Optional |

`Enigma#crack(ciphertext, date)`

| Argument | Description | Requirement |
| ----- | ----- |-----|
| Ciphertext | The string to be decoded (symbols, numbers and escape characters will not be transformed) (assumption that all messages end with ' end')| Required |
| Date | DDMMYY format | Optional |

## Example
```ruby
$ require './lib/enigma'
#=> true
$ enigma = Enigma.new
#=> #<Enigma:0x007fbc4781fed8>

# encrypt a message with a key and date
$ enigma.encrypt("hello world", "93890", "150819")
#=>
#   {
#     encryption: "twzv rjyccr",
#     key: "93890",
#     date: "150819"
#   }

# decrypt a message with a key and date
$ enigma.decrypt("twzv rjyccr", "93890", "150819")
#=>
#   {
#     decryption: "hello world",
#     key: "93890",
#     date: "150819"
#   }

# encrypt a message with a key (uses today's date)
$ encrypted = enigma.encrypt("hello world", "93890")
#=> # encryption hash here

#decrypt a message with a key (uses today's date)
$ enigma.decrypt(encrypted[:encryption], "93890")
#=> # decryption hash here

# encrypt a message (generates random key and uses today's date)
$ enigma.encrypt("hello world")
#=> # encryption hash here

$ enigma.encrypt("hello world end", "95009", "150819")
#=>
#   {
#     encryption: "vhrvbcbyeojjsqj",
#     key: "95009",
#     date: "150819"
#   }

# crack an encryption with a date
$ enigma.crack("vhrvbcbyeojjsqj", "150819")
#=>
#   {
#     decryption: "hello world end",
#     key: "95009",
#     date: "150819"
#   }

# crack an encryption (uses today's date)
$ enigma.crack("vhrvbcbyeojjsqj")
#=>
#   {
#     decryption: "hello world end",
#     date: # todays date in the format DDMMYY,
#     key: # key used for encryption
#   }
```

## How to use the command line interface

### Encrypting & Decrypting
`encrypt.rb` takes 2 command line arguments. `message.txt` is an existing file with the message to be encrypted. `encrypted.txt` is where the program should write the encoded message.

In addition to writing the encrypted message to the file, the program outputs to the screen the file it wrote to, the key and the date.

`decrypt.rb` takes 4 command line arguments. `encrypted.txt` is an existing file with the message to be decoded. `decrypted.txt` is where the program should write the decoded message. Then the 5-digit key and the date to be used for decryption.

In addition to writing the decrypted message to the file, the program outputs to the screen the file it wrote to, the key and the date.

### Example
```
$ ruby ./lib/encrypt.rb message.txt encrypted.txt
Created 'encrypted.txt' with the key 95009 and date 150819
$ ruby ./lib/decrypt.rb encrypted.txt decrypted.txt 95009 150819
Created 'decrypted.txt' with the key 95009 and date 150819
```
### Cracking
`crack.rb` takes 3 command line arguments. `encrypted.txt` is an existing file with the message to be decoded. `cracked.txt` is where the program should write the cracked message. And the date to be used for decryption.

In addition to writing the decrypted message to the file, the program outputs to the screen the file it wrote to, the key and the date.
```
$ ruby ./lib/encrypt.rb message.txt encrypted.txt
Created 'encrypted.txt' with the key 95009 and date 150819
$ ruby ./lib/crack.rb encrypted.txt cracked.txt 150819
Created 'cracked.txt' with the cracked key 95009 and date 150819
```

## Built With
* Ruby 2.4.1

## Testing
All test are done with RSpec with a 100% code coverage (calculated with [SimpleCov](https://github.com/colszowka/simplecov))

To run all tests, enter in your terminal:
```
$ cd enigma2
$ rspec
```

To run a single test:
```
$ cd enigma2
$ rspec spec/enigma_spec.rb
```