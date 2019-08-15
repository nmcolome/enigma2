require './spec/spec_helper'
require './lib/enigma'

RSpec.describe 'Enigma' do
  before(:all) do
    @enigma = Enigma.new
  end

  it 'exists' do
    expect(@enigma).to be_an_instance_of Enigma
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

    context 'when a message has capital letters' do
      it do
        result = {
          encryption: 'keder ohulw',
          key: '02715',
          date: '040895'
        }

        expect(@enigma.encrypt('HELLO WORLd', '02715', '040895')).to eq result
      end
    end
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
