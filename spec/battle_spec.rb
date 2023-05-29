require 'spec_helper'

RSpec.describe Battle do 
  before do
    @battle = Battle.new
    @cruiser = @battle.ships[0]
    @submarine = @battle.ships[1]
  end

  it 'exists' do
    expect(@battle).to be_a(Battle)
  end

  it 'starts with computer and user health at 0' do
    expect(@battle.computer_health).to eq(0)
    expect(@battle.user_health).to eq(0)
  end

  it 'initializes with computer and user boards' do
    expect(@battle.computer_board).to be_a(Board)
    expect(@battle.user_board).to be_a(Board)
  end

  it 'has two ships by default' do
    expect(@battle.ships).to be_a(Array)
    expect(@battle.ships.first).to be_a(Ship)
    expect(@battle.ships.first.name).to eq("Cruiser")
    expect(@battle.ships.length).to eq(2)
  end

  it 'welcomes the player' do
    expect{@battle.welcome}.to output("Welcome to BATTLESHIP\nEnter p to play. Enter q to quit.\n").to_stdout
  end
  
  it 'can select a random valid placement for ships' do
    coordinates_1 = @battle.generate_placement(@cruiser)
    expect(coordinates_1).to be_a(Array)
    expect(coordinates_1.length).to eq(3)
    expect(@battle.computer_board.valid_placement?(@cruiser, coordinates_1)).to eq(true)
    coordinates_2 = @battle.generate_placement(@submarine)
    expect(coordinates_2.length).to eq(2)
    expect(@battle.computer_board.valid_placement?(@submarine, coordinates_2)).to eq(true)
  end

  it 'can place all ships' do
    @battle.place_computer_ships
    expect(@battle.computer_health).to eq(5)
  end

  it 'prints instructions' do
    expect(@battle).to respond_to(:instructions)
  end

  it 'prompts user to place ships' do
    expect(@battle).to respond_to(:user_ship_placement)
  end

  #quit method?
  #Quit method not necessary. Program will teminate itself by default unless we tell it to move to another method.

end