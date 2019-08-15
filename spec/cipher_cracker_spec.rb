require './spec/spec_helper'
require './lib/cipher'
require './lib/cipher_cracker'

RSpec.describe 'CipherCracker' do
  before(:all) do
    @cipher = Cipher.new
    @cipher_cracker = CipherCracker.new
    @msg1 = @cipher.encrypt('hello world end', '11228', '150819')
    @msg2 = @cipher.encrypt('hello world end', '07280', '150819')
    # offset = [0, 7, 6, 1]
  end

  it '#crack_shifts' do
    ciphertext1 = @msg1[:encryption]
    ciphertext2 = @msg2[:encryption]

    expect(@cipher_cracker.crack_shifts(ciphertext1)).to eq [38, 19, 28, 2]
    expect(@cipher_cracker.crack_shifts(ciphertext2)).to eq [34, 25, 34, 27]
  end

  it '#crack_rotations' do
    ending1 = @msg1[:encryption][-4..-1]
    ending2 = @msg2[:encryption][-4..-1]

    expect(@cipher_cracker.crack_rotations(ending1)).to eq [2, 38, 19, 28]
    expect(@cipher_cracker.crack_rotations(ending2)).to eq [27, 34, 25, 34]
  end

  describe '#possible_keys' do
    context 'when there is only one valid key' do
      it do
        initial_keys = [11, 12, 22, 1]
        possible_keys = [
          [11, 38, 65, 92],
          [12, 39, 66, 93],
          [22, 49, 76, 103],
          [1, 28, 55, 82]
        ]

        expect(@cipher_cracker.possible_keys(initial_keys)).to eq possible_keys
      end
    end

    context 'when there are several valid combinations' do
      it do
        initial_keys = [7, 18, 1, 26]
        possible_keys = [
          [7, 34, 61, 88],
          [18, 45, 72, 99],
          [1, 28, 55, 82],
          [26, 53, 80, 107]
        ]

        expect(@cipher_cracker.possible_keys(initial_keys)).to eq possible_keys
      end
    end
  end

  describe '#get_matches' do
    context 'when there is only one valid key' do
      it do
        a = [11, 38, 65, 92]
        b = [12, 39, 66, 93]
        c = [22, 49, 76, 103]
        d = [1, 28, 55, 82]

        expect(@cipher_cracker.get_matches(a, b)).to eq [[11, 12]]
        expect(@cipher_cracker.get_matches(c, d)).to eq [[22, 28]]
      end
    end

    context 'when there are several valid combinations' do
      it do
        a = [7, 34, 61, 88]
        b = [18, 45, 72, 99]
        c = [1, 28, 55, 82]
        d = [26, 53, 80, 107]
        ab_result = [[7, 72], [34, 45], [61, 18]]
        cd_result = [[28, 80], [55, 53], [82, 26]]

        expect(@cipher_cracker.get_matches(a, b)).to eq ab_result
        expect(@cipher_cracker.get_matches(c, d)).to eq cd_result
      end
    end
  end

  describe '#get_valid_keys' do
    context 'when there is only one valid key' do
      it do
        ab1 = [[11, 12]]
        cd1 = [[22, 28]]
        abcd1 = [[11, 12, 22, 28]]

        expect(@cipher_cracker.get_valid_keys(ab1, cd1)).to eq abcd1
      end
    end

    context 'when there are several valid combinations' do
      it do
        ab2 = [[7, 72], [34, 45], [61, 18]]
        cd2 = [[28, 80], [55, 53], [82, 26]]
        result = [[7, 72, 28, 80], [34, 45, 55, 53], [61, 18, 82, 26]]

        expect(@cipher_cracker.get_valid_keys(ab2, cd2)).to eq result
      end
    end
  end

  it '#turn_to_text' do
    keys = [11, 12, 22, 28]

    expect(@cipher_cracker.turn_to_text(keys)).to eq '11228'
  end

  it '#crack_keys' do
    ciphertext = @msg1[:encryption]
    date = '150819'

    expect(@cipher_cracker.crack_keys(ciphertext, date)).to eq '11228'
  end
end
