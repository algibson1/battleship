require 'spec_helper'

RSpec.describe Board do
  before do 
    @board = Board.new
  end

  it 'exists' do
    expect(@board).to be_a(Board)
  end

  
end