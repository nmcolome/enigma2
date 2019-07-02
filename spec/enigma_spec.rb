require './spec/spec_helper'
require './lib/enigma'
require 'pry'

RSpec.describe 'Enigma' do
  before(:all) do
    @enigma = Enigma.new
  end

  it 'exists' do
    expect(@enigma).to be_an_instance_of Enigma
  end

  it '#character_set' do
    result = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', ' ']

    expect(@enigma.character_set).to eq result
  end

  describe '#encrypt' do
    context 'when a key and date are provided' do
      it do
        result = {
          encryption: 'keder ohulw',
          key: '02715',
          date: '040895'
        }

        expect(@enigma.encrypt('hello world', '02715', '040895')).to eq result
      end
    end

    context 'when only a key is provided' do
      xit do
        result = {
          encryption: 'mfhatasdwm ',
          key: '02715',
          date: '250619'
        }

        expect(@enigma.encrypt('hello world', '02715')).to eq result
      end
    end
  end

  it '#get_keys' do
    expect(@enigma.get_keys('02715')).to eq %w[02 27 71 15]
  end

  it '#get_offsets' do
    expect(@enigma.get_offsets('040895')).to eq %w[1 0 2 5]
  end

  it '#get_shifts' do
    keys = %w[02 27 71 15]
    offsets = %w[1 0 2 5]

    expect(@enigma.get_shifts('02715', '040895')).to eq [3, 0, 19, 20]
  end

  it '#code_msg' do
    msg = 'hello world'
    shifts = [3, 0, 19, 20]
    result = 'keder ohulw'.split('')

    expect(@enigma.code_msg(msg, shifts)).to eq result
  end
end