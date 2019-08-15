require './spec/spec_helper'
require './lib/cipher'

RSpec.describe 'Cipher' do
  before(:all) do
    @cipher = Cipher.new
  end

  it '#character_set' do
    result = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', ' ']

    expect(@cipher.character_set).to eq result
  end

  it '#get_keys' do
    expect(@cipher.get_keys('02715')).to eq %w[02 27 71 15]
  end

  it '#get_offsets' do
    expect(@cipher.get_offsets('040895')).to eq %w[1 0 2 5]
  end

  it '#get_shifts' do
    expect(@cipher.get_shifts('02715', '040895')).to eq [3, 0, 19, 20]
  end

  it '#transform_msg' do
    msg = 'hello world'
    shifts = [3, 0, 19, 20]
    result = 'keder ohulw'.split('')

    expect(@cipher.transform_msg(msg, shifts, 'code')).to eq result
  end
end
