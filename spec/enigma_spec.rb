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

  it '#key_generator' do
    expect(@enigma.key_generator).to be_an_instance_of String
    expect(@enigma.key_generator.length).to eq 5
  end

  it '#date_generator' do
    expect(@enigma.date_generator).to be_an_instance_of String
    expect(@enigma.date_generator.length).to eq 6
  end

  describe '#encrypt' do
    context 'when a message, key and date are provided' do
      it do
        result = {
          encryption: 'keder ohulw',
          key: '02715',
          date: '040895'
        }

        expect(@enigma.encrypt('hello world', '02715', '040895')).to eq result
      end
    end

    context 'when only a message and key are provided' do
      it do
        result = {
          encryption: 'pnhawisdzu ',
          key: '02715',
          date: '020719'
        }

        @enigma.stub(:date_generator) { '020719' }
        expect(@enigma.encrypt('hello world', '02715')).to eq result
      end
    end

    context 'when only a message is provided' do
      it do
        result = {
          encryption: 'zjydfeigiqq',
          key: '12345',
          date: '020719'
        }

        @enigma.stub(:key_generator) { '12345' }
        @enigma.stub(:date_generator) { '020719' }
        expect(@enigma.encrypt('hello world')).to eq result
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
    expect(@enigma.get_shifts('02715', '040895')).to eq [3, 0, 19, 20]
  end

  it '#transform_msg' do
    msg = 'hello world'
    shifts = [3, 0, 19, 20]
    result = 'keder ohulw'.split('')

    expect(@enigma.transform_msg(msg, shifts, 'code')).to eq result
  end

  describe '#decrypt' do
    context 'when a message, key and date are provided' do
      it do
        result = {
          decryption: 'hello world',
          key: '02715',
          date: '040895'
        }

        expect(@enigma.decrypt('keder ohulw', '02715', '040895')).to eq result
      end
    end

    context 'when only a message and key are provided' do
      it do
        result = {
          decryption: 'hello world',
          key: '02715',
          date: '020719'
        }

        @enigma.stub(:date_generator) { '020719' }
        expect(@enigma.decrypt('pnhawisdzu ', '02715')).to eq result
      end
    end
  end

  describe '#crack' do
    context 'when a message and date are provided' do
      it do
        msg = @enigma.encrypt('hello world end', '08304', '291018')
        result = {
          decryption: 'hello world end',
          key: '08304',
          date: '291018'
        }

        expect(@enigma.crack(msg[:encryption], '291018')).to eq result
      end
    end

    context 'when only a message is provided' do
      it do
        msg = @enigma.encrypt('hello world end', '08304', '020719')
        result = {
          decryption: 'hello world end',
          key: '08304',
          date: '020719'
        }

        @enigma.stub(:date_generator) { '020719' }
        expect(@enigma.crack(msg[:encryption])).to eq result
      end
    end
  end
end
