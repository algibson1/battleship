require 'spec_helper'

RSpec.describe Cell do
  before do
    @cell = Cell.new("B4")
    @cruiser = Ship.new("Cruiser", 3)
    @cell_1 = Cell.new("D2")
    @cell_2 = Cell.new("C3")
  end

  it 'exists' do
    expect(@cell).to be_a(Cell)
  end

  it 'initializes with a coordinate' do
    expect(@cell.coordinate).to eq("B4")
  end

  it 'has no ship by default' do
    expect(@cell.ship).to be_nil
  end

  it 'has no ship, so it is empty' do
    expect(@cell.empty?).to eq(true)
  end

  it 'can place a ship' do
    @cell.place_ship(@cruiser)
    expect(@cell.ship).to eq(@cruiser)
    expect(@cell.empty?).to eq(false)
  end

  it 'can tell if it has been fired upon' do
    @cell.place_ship(@cruiser)
    expect(@cell.fired_upon?).to eq(false)
  end

  it 'can be fired upon' do
    @cell.place_ship(@cruiser)
    @cell.fire_upon 
    expect(@cell.ship.health).to eq(2)
    expect(@cell.fired_upon?).to eq(true)
  end

  it 'can render differently depending on ship and fire status' do
    expect(@cell_1.render).to eq(".")
    @cell_1.fire_upon 
    expect(@cell_1.render).to eq("M")
    @cell_2.place_ship(@cruiser)
    expect(@cell_2.render).to eq(".")
    expect(@cell_2.render(true)).to eq("S")
    @cell_2.fire_upon 
    expect(@cell_2.render).to eq("H")
    expect(@cruiser.sunk?).to eq(false)
    @cruiser.hit
    @cruiser.hit
    expect(@cruiser.sunk?).to eq(true)
    expect(@cell_2.render).to eq("X")
  end

end