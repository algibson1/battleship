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

  it 'has valid and unvalid cell coordinates' do
    expect(@board.valid_coordinate?("A1")).to eq(true)
    expect(@board.valid_coordinate?("D4")).to eq(true)
    expect(@board.valid_coordinate?("A5")).to eq(false)
    expect(@board.valid_coordinate?("E1")).to eq(false)
    expect(@board.valid_coordinate?("A22")).to eq(false)
  end
end