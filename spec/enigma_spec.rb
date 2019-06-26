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

  it '#encrypt' do
    result = {
      encryption: 'keder ohulw',
      key: '02715',
      date: '040895'
    }

    expect(@enigma.encrypt('hello world', '02715', '040895')).to eq result
  end
end