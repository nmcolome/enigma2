require './spec/spec_helper'
require './lib/encrypt'

RSpec.describe 'Encrypt' do
  before(:all) do
    @encryptor = Encrypt.new
  end

  it 'exists' do
    expect(@encryptor).to be_an_instance_of Encrypt
  end

  it '#get_keys' do
    expect(@encryptor.get_keys('02715')).to eq %w[02 27 71 15]
  end

  it '#get_offsets' do
    expect(@encryptor.get_offsets('040895')).to eq %w[1 0 2 5]
  end

  it '#get_shifts' do
    expect(@encryptor.get_shifts('02715', '040895')).to eq [3, 0, 19, 20]
  end

  it '#transform_msg' do
    msg = 'hello world'
    shifts = [3, 0, 19, 20]
    result = 'keder ohulw'.split('')

    expect(@encryptor.transform_msg(msg, shifts, 'code')).to eq result
  end
end
