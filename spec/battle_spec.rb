require 'spec_helper'

RSpec.describe Battle do 
  before do
    @board = Board.new
    @battle = Battle.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  it 'exists' do
    expect(@battle).to be_a(Battle)
  end

  it 'has a computer and user health' do
    expect(@battle.computer_health).to eq(0)
    expect(@battle.user_health).to eq(0)
  end

  it 'initializes with computer and user boards' do
    expect(@battle.computer_board).to be_a(Board)
    expect(@battle.user_board).to be_a(Board)
  end

  it 'can have ships' do
    expect(@battle.ships).to be_a(Array)
    expect(@battle.ships.first).to be_a(Ship)
    expect(@battle.ships.first.name).to eq("Cruiser")
    expect(@battle.ships.length).to eq(2)
  end

  it 'welcomes the player' do
    expect(@battle.welcome).to eq("Welcome to BATTLESHIP\nEnter p to play. Enter q to quit.")
  end
  
  it 'can select a random valid placement for ships' do
    coordinates = @battle.generate_placement(@cruiser)
    expect(coordinates).to be_a(Array)
    expect(@board.valid_placement?(@cruiser, coordinates)).to eq(true)
  end

  it 'can place all ships' do
    @battle.place_computer_ships
    expect(@battle.computer_health).to eq(5)
  end

  it 'prints instructions' do
    expect(@battle.instructions).to eq("I have laid out my ships on the grid.\nYou now need to lay out your ships.\nThe Cruiser is three units long and the Submarine is two units long.\n  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n")
  end

  #quit method?

end