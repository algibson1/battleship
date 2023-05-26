require 'spec_helper'

RSpec.describe Board do
  before do 
    @board = Board.new
  end

  it 'exists' do
    expect(@board).to be_a(Board)
  end

  it 'is initialized with cells' do
    cells = @board.cells
    expect(cells).to be_a(Hash)
    expect(cells.count).to eq(16)
    expect(cells.values.first).to be_a(Cell)
  end
end