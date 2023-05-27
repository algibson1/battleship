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

  it 'can check if cell is already occupied' do
    @board.place(@cruiser, ["A1", "A2", "A3"])
    expect(@board.unoccupied?("A1")).to eq(false)
    expect(@board.unoccupied?("A2")).to eq(false)
    expect(@board.unoccupied?("A3")).to eq(false)
    expect(@board.unoccupied?("A4")).to eq(true)
  end

  it 'can check if all unoccupied' do
    @board.place(@cruiser, ["A1", "A2", "A3"])
    expect(@board.all_unoccupied?(["A1", "B1"])).to eq(false)
  end

  it 'cannot overlap ships' do
    @board.place(@cruiser, ["A1", "A2", "A3"])
    expect(@board.valid_placement?(@submarine, ["A1", "B1"])).to eq(false)
  end

  it 'can render a row of numbered columns' do
    expect(@board.render_number_row).to eq("  1 2 3 4 \n")
  end

  it 'can render each row of cells' do
    @board.place(@cruiser, ["A1", "A2", "A3"])
    cell_1 = @board.cells["A1"]
    cell_1.fire_upon
    cell_2 = @board.cells["A4"]
    cell_2.fire_upon
    expect(@board.render_cell_row("A")).to eq("A H . . M \n")
    expect(@board.render_cell_row("A", true)).to eq("A H S S M \n")
  end

  it 'can render a board to terminal' do
    @board.place(@cruiser, ["A1", "A2", "A3"])
    expect(@board.render).to eq("  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n")
    expect(@board.render(true)).to eq("  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n")
  end

  it 'can render board of alternate size to terminal' do
    board_2 = Board.new(5, 7)
    expect(board_2.render).to eq("  1 2 3 4 5 6 7 \nA . . . . . . . \nB . . . . . . . \nC . . . . . . . \nD . . . . . . . \nE . . . . . . . \n")
  end

  it 'can render board with sunken ships, hits, and misses' do
    @board.place(@cruiser, ["A1", "A2", "A3"])
    cell_1 = @board.cells["A1"]
    cell_2 = @board.cells["A2"]
    cell_3 = @board.cells["A3"]
    cell_4 = @board.cells["B2"]
    cell_5 = @board.cells["C3"]
    cell_1.fire_upon 
    cell_2.fire_upon
    cell_4.fire_upon
    cell_5.fire_upon
    expect(@board.render).to eq("  1 2 3 4 \nA H H . . \nB . M . . \nC . . M . \nD . . . . \n")
    cell_3.fire_upon 
    expect(@board.render).to eq("  1 2 3 4 \nA X X X . \nB . M . . \nC . . M . \nD . . . . \n")
  end
end