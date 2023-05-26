require 'spec_helper'

RSpec.describe Cell do
  before do
    @cell = Cell.new("B4")
    @cruiser = Ship.new("Cruiser", 3)
  end

  it 'exists' do
    expect(@cell).to be_a(Cell)
  end

  xit 'initializes with a coordinate' do
    expect(@cell.coordinate).to eq("B4")
  end

  xit 'has no ship by default' do
    expect(@cell.ship).to be_nil
  end

  xit 'has no ship, so it is empty' do
    expect(@cell.empty?).to eq(true)
  end

  xit 'can get a ship' do
    @cell.place_ship(@cruiser)
    expect(@cruiser.ship).to eq(cruiser)
    expect(@cell.empty?).to eq(false)
  end

  xit 'can tell if it has been fired upon' do
    @cell.place_ship(@cruiser)
    expect(@cell.fired_upon?).to eq(false)
  end

  xit 'can be fired upon' do
    @cell.place_ship(@cruiser)
    @cell.fire_upon 
    expect(@cell.ship.health).to eq(2)
    expect(@cell.fired_upon?).to eq(true)
  end
end