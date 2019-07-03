require './spec/spec_helper'
require './lib/decrypt'

RSpec.describe 'Decrypt' do
  before(:all) do
    @decryptor = Decrypt.new
  end

  it 'exists' do
    expect(@decryptor).to be_an_instance_of Decrypt
  end
end
