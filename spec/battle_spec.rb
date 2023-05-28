require 'spec_helper'

RSpec.describe Battle do 
  before do
    @board = Board.new
    @battle = Battle.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  it 'has a computer health' do
    expect(@battle.computer_health).to eq(0)
  end

  it 'initializes with computer and user boards' do
    expect(@battle.computer_board).to be_a(Board)
    expect(@battle.user_board).to be_a(Board)
  end

  it 'can have ships' do
    expect(@battle.ships).to eq([@cruiser, @submarine])
  end

  it 'welcomes the player' do
    expect(@battle.welcome).to eq("Welcome to BATTLESHIP\nEnter p to play. Enter q to quit.")
  end
  
  it 'can select a random valid placement for ships' do
    coordinates = @battle.generate_placement(@cruiser)
    expect(coordinates).to be_a(Array)
    expect(@board.valid_placement?(coordinates)).to eq(true)
    expect
  end

  it 'can place all ships' do
    @battle.place_computer_ships
    expect(@battle.computer_health).to eq(5)
  end

  it 'prints instructions' do
    expect(@battle.instructions).to eq("I have laid out my ships on the grid.\nYou now need to lay out your two ships.\nThe Cruiser is three units long and the Submarine is two units long.\n  1 2 3 4\n
      A . . . .\n
      B . . . .\n
      C . . . .\n
      D . . . .\nEnter the squares for the Cruiser (3 spaces):")
  end

  it 'can place user ship' do
    @battle.place_user_ship(@cruiser, ["A1", "A2", "A3"])
    expect(@battle.user_board.render).to eq("  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . .")
    @battle.place_user_ship(@submarine, ["C1", "D1"])
    expect(@battle.user_board.render).to eq("  1 2 3 4 \nA S S S . \nB . . . . \nC S . . . \nD S . . .")
  end

  it 'can prompt to pick different coordinates' do
   expect(@battle.place_user_ship(@cruiser, ["A1", "A3", "A4"])).to eq("Sorry those are invalid coordinates. Please try again.")
   expect(@battle.user_board.render).to eq("  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . .")
  end

  

end