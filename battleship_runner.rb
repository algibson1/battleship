require './spec/spec_helper'

battle = Battle.new

battle.place_computer_ships
puts battle.computer_board.render(true)
# battle.welcome