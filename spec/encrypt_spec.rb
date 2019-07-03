require './spec/spec_helper'
require './lib/encrypt'

RSpec.describe 'Encrypt' do
  before(:all) do
    @encryptor = Encrypt.new
  end

  it 'exists' do
    expect(@encryptor).to be_an_instance_of Encrypt
  end
end