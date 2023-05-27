require 'spec_helper'

RSpec.describe Board do
  before do 
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  it 'exists' do
    expect(@board).to be_a(Board)
  end

  it 'is initialized as 4x4 by default' do
    cells = @board.cells
    expect(cells).to be_a(Hash)
    expect(cells.count).to eq(16)
    expect(cells.values.first).to be_a(Cell)
  end

  it 'can have dynamic board size' do
    board_2 = Board.new(5, 7)
    cells = board_2.cells
    expect(cells.count).to eq(35)
  end

  it 'has valid and invalid cell coordinates' do
    expect(@board.valid_coordinate?("A1")).to eq(true)
    expect(@board.valid_coordinate?("D4")).to eq(true)
    expect(@board.valid_coordinate?("A5")).to eq(false)
    expect(@board.valid_coordinate?("E1")).to eq(false)
    expect(@board.valid_coordinate?("A22")).to eq(false)
  end

  it 'can check if any coordinates in range are invalid' do
    expect(@board.all_valid_coordinates?(["A3", "A4", "A5"])).to eq(false)
    expect(@board.all_valid_coordinates?(["A1", "A2", "A3"])).to eq(true)
  end

  it 'can not place ships with invalid coordinates' do
    expect(@board.valid_placement?(@cruiser, ["A3", "A4", "A5"])).to eq(false)
  end

  it 'checks length of coordinates vs ship' do
    expect(@board.length_match?(@cruiser, ["A1", "A2"])). to eq(false)
    expect(@board.length_match?(@cruiser, ["A1", "A1", "A3"])).to eq(true)
  end

  it 'returns invalid if ship length does not match coordinates given' do
    expect(@board.valid_placement?(@cruiser, ["A1", "A2"])).to eq(false)
    expect(@board.valid_placement?(@submarine, ["A2", "A3", "A4"])).to eq(false)
  end

  it 'checks if coordinates are consecutive' do
    expect(@board.consecutive?(["A1", "A2", "A4"])).to eq(false)
    expect(@board.consecutive?(["A1", "A2", "A3"])).to eq(true)
    expect(@board.consecutive?(["A3", "A2", "A1"])).to eq(false)
    expect(@board.consecutive?(["A1", "B1", "C1"])).to eq(true)
  end

  it 'returns invalid if coordinates not consecutive' do
    expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A4"])).to eq(false)
    expect(@board.valid_placement?(@submarine, ["A1", "C1"])).to eq(false)
    expect(@board.valid_placement?(@cruiser, ["A3", "A2", "A1"])).to eq(false)
    expect(@board.valid_placement?(@submarine, ["C1", "B1"])).to eq(false)
  end

  it 'can check coordinates are in same column or row' do
    expect(@board.not_diagonal?(["A1", "B2", "C3"])).to eq(false)
    expect(@board.not_diagonal?(["C2", "D3"])).to eq(false)
    expect(@board.not_diagonal?(["A1", "B1", "C1"])).to eq(true)
    expect(@board.not_diagonal?(["A1", "A2", "A3"])).to eq(true)
  end

  it 'can not place ships diagonally' do
    expect(@board.valid_placement?(@cruiser, ["A1", "B2", "C3"])).to eq(false)
    expect(@board.valid_placement?(@submarine, ["C2", "D3"])).to eq(false)
  end

  it 'can determine if ship placement is valid' do
    expect(@board.valid_placement?(@submarine, ["A1", "A2"])).to eq(true)
    expect(@board.valid_placement?(@cruiser, ["B1", "C1", "D1"])).to eq(true)
  end

  it 'can place ships' do
    @board.place(@cruiser, ["A1", "A2", "A3"])
    cell_1 = @board.cells["A1"]
    cell_2 = @board.cells["A2"]
    cell_3 = @board.cells["A3"]
    expect(cell_1.ship).to eq(@cruiser)
    expect(cell_2.ship).to eq(@cruiser)
    expect(cell_3.ship).to eq(@cruiser)
    expect(cell_3.ship == cell_2.ship).to eq(true)
  end
end