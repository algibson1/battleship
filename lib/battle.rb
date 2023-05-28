class Battle
  attr_reader :computer_health,
              :user_health,
              :computer_board,
              :user_board,
              :ships

  def initialize
    @computer_health = 0
    @user_health = 0
    @computer_board = Board.new
    @user_board = Board.new
    @ships = [Ship.new("Cruiser", 3), Ship.new("Submarine", 2)]
  end

  def welcome
    puts "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit."
    user_input = gets.chomp
    if user_input == "p" 
      #placeholder: "customize" method. Ask player if they'd like to play a custom game or standard game. Custom choice: reassigns board size and ships. Standard choice: moves forward with the defaults we already made
      place_computer_ships
      instructions
    elsif user_input == "q"
    end
  end

  def generate_placement(ship)
    all_possible_sets = @computer_board.cells.keys.permutation(ship.length).to_a
    valid_placements = all_possible_sets.find_all do |coordinate_set|
      @computer_board.valid_placement?(ship, coordinate_set)
    end
    valid_placements.sample
  end

  def place_computer_ships
    @ships.each do |ship|
      @computer_board.place(ship, generate_placement(ship))
      @computer_health += ship.health
    end
  end

  def instructions
    puts "I have laid out my ships on the grid.\nYou now need to lay out your ships.\nThe Cruiser is three units long and the Submarine is two units long.\n#{@user_board.render(true)}"
    user_ship_placement
  end

  def user_ship_placement
    @ships.each do |ship|
      puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"
      coordinates = gets.chomp.split
      until @user_board.valid_placement?(ship, coordinates)
        puts "Those are invalid coordinates. Please try again."
        coordinates = gets.chomp.split
      end
      @user_board.place(ship, coordinates)
      @user_health += ship.health
      puts @user_board.render(true)
    end
  end
end