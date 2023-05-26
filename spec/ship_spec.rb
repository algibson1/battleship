require 'spec_helper'

RSpec.describe Ship do
  before do 
    @cruiser = Ship.new("Cruiser", 3)
  end

  it 'exists' do
    expect(@cruiser).to be_a(Ship)
  end

  it 'initializes with name length and health' do
    expect(@cruiser.name).to eq("Cruiser")
    expect(@cruiser.length).to eq(3)
    expect(@cruiser.health).to eq(3)
  end

  it 'is not sunk by default' do
    expect(@cruiser.sunk?).to be(false)
  end

  it 'can get hit' do
    @cruiser.hit
    expect(@cruiser.health).to eq(2)
    @cruiser.hit
    expect(@cruiser.health).to eq(1)
  end

  it 'sinks when health equals 0' do
  @cruiser.hit
  @cruiser.hit
  expect(@cruiser.sunk?).to eq(false)
  @cruiser.hit
  expect(@cruiser.health).to eq(0)
  expect(@spec hcruiser.sunk?).to eq(true)
  end
end