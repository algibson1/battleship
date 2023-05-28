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
    return "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit."
    user_input = gets.chomp
    if user_input == p 
      set_up
    elsif user_input == q
      quit
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
    return "I have laid out my ships on the grid.\nYou now need to lay out your ships.\nThe Cruiser is three units long and the Submarine is two units long.\n#{@user_board.render(true)}"
  end

  def user_ship_placement
    return "Enter the squares for the Cruiser (3 spaces):"
    coordinates = gets.chomp 
    while !@user_board.valid_placement?(@ships.first, coordinates)
      "Those are invalid coordinates. Please try again."
      coordinates = gets.chomp
    end
    @user_board.place(@ships.first, coordinates)
    @user_health += @ships.first.health
    @user_board.render(true)
    return "Enter the squares for the Submarine (2 spaces):"
    coordinates_2 = gets.chomp 
    while !@user_board.valid_placement?(@ships.last, coordinates_2)
      "Those are invalid coordinates. Please try again."
      coordinates_2 = gets.chomp
    end
    @user_board.place(@ships.last, coordinates_2)
    @user_health += @ships.last.health
  end
end