require 'spec_helper'

RSpec.describe Battle do 
  before do
    @battle = Battle.new
    @cruiser = @battle.computer_ships[0]
    @submarine = @battle.computer_ships[1]
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

  it 'has two ships for computer and user by default' do
    expect(@battle.computer_ships).to be_a(Array)
    expect(@battle.computer_ships.first).to be_a(Ship)
    expect(@battle.computer_ships.first.name).to eq("Cruiser")
    expect(@battle.computer_ships.length).to eq(2)
  end

  it 'welcomes the player' do
    expect(@battle).to respond_to(:welcome)
  end

  it 'has a method to run all game methods' do
    expect(@battle).to respond_to(:play_game)
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

  it 'sets up game' do
    expect(@battle).to respond_to(:set_up)
  end

  it 'prompts user to place ships' do
    expect(@battle).to respond_to(:user_ship_placement)
  end

  it 'sets up a turn' do
    expect(@battle).to respond_to(:turn_setup)
  end

  it 'fires player shot' do
    expect(@battle.computer_board.cells["A1"].fired_upon?).to eq(false)
    @battle.fire_player_shot("A1")
    expect(@battle.computer_board.cells["A1"].fired_upon?).to eq(true)
  end

  it 'generates a random computer shot' do
    random_shot = @battle.generate_computer_shot
    expect(random_shot).to be_a(String)
    expect(@battle.user_board.valid_coordinate?(random_shot)).to eq(true)
    expect(@battle.user_board.cells[random_shot].fired_upon?).to eq(false)
  end

  it 'calculates results' do
    @battle.user_board.place(@cruiser, ["B1", "B2", "B3"])
    @battle.computer_board.place(@submarine, ["A3", "A4"])
    @battle.computer_board.cells["A3"].fire_upon
    @battle.user_board.cells["A2"].fire_upon
    results_1 = @battle.calculate_results("A3", "A2")
    expect(results_1).to eq(["hit", "miss"])
    @battle.computer_board.cells["A4"].fire_upon
    @battle.user_board.cells["B2"].fire_upon
    results_2 = @battle.calculate_results("A4", "B2")
    expect(results_2).to eq(["hit", "hit"])
    expect(@submarine.sunk?).to eq(true)
  end

  it 'displays results' do
    expect{@battle.display_results("A1", "A2", ["hit", "miss"])}.to output("Your shot on A1 was a hit.\nMy shot on A2 was a miss.\n---\n").to_stdout
  end

  it 'can run a full turn' do
    expect(@battle).to respond_to(:take_turn)
  end

  it 'has an ending' do
    expect(@battle).to respond_to(:end_game)
  end

  it 'resets the game when over' do
    @battle.place_computer_ships
    expect(@battle.computer_health).to eq(5)
    @battle.computer_ships.first.hit
    expect(@battle.computer_ships.first.health).to eq(2)
    @battle.reset
    expect(@battle.computer_health).to eq(0)
    expect(@battle.computer_ships.first.health).to eq(3)
  end
end