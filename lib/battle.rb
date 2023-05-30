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
      set_up
    elsif user_input == "q"
      #edit later to account for alternative answers
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

  def set_up
    puts "I have laid out my ships on the grid.\nYou now need to lay out your ships.\nThe Cruiser is three units long and the Submarine is two units long.\n#{@user_board.render(true)}"
    user_ship_placement
    take_turn
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

  def turn_setup
    puts "==========COMPUTER BOARD=========="
    puts @computer_board.render
    puts "==========PLAYER BOARD=========="
    puts @user_board.render(true)
    puts "Enter the coordinate for your shot:"
  end

  def fire_player_shot(shot)
    until @computer_board.valid_coordinate?(shot) && 
      !@computer_board.cells[shot].fired_upon?
      if !@computer_board.valid_coordinate?(shot)
        puts "Please enter a valid coordinate"
      else
        #cannot choose a cell that has already been fired upon
        puts "You already shot that square! Pick another:"
      end
      shot = gets.chomp
    end
    @computer_board.cells[shot].fire_upon
  end

  def generate_computer_shot
    valid_cells = @user_board.cells.select do |coordinate, cell|
      cell.fired_upon? == false
    end
    valid_cells.keys.sample
  end

  def calculate_results(user_shot, computer_shot)
    user_render = @computer_board.cells[user_shot].render
    computer_render = @user_board.cells[computer_shot].render
    rendered_results = [user_render, computer_render]
    results = []
    rendered_results.each do |result|
      if result == "X" || result == "H"
        results << "hit"
      else 
        results << "miss"
      end
    end
    results
  end
  #psuedocode below
  # take turn method
  def take_turn
    until @user_health == 0 || @computer_health == 0
      turn_setup
      user_shot = gets.chomp
      fire_player_shot(user_shot)
      computer_shot = generate_computer_shot
      @user_board.cells[computer_shot].fire_upon
      #results
      results = calculate_results(user_shot, computer_shot)
      puts "Your shot on #{user_shot} was a #{results[0]}"
      puts "My shot on #{computer_shot} was a #{results[1]}"
      puts "---"
      if @user_board.cells[computer_shot].ship.sunk?
        puts "Get SUNK! I sank your #{@user_board.cells[computer_shot].ship.name}!"
      end
      if @computer_board.cells[user_shot].ship.sunk?
        puts "Oh no, you sunk my #{@computer_board.cells[user_shot].ship.name}!"
      end
      if results[0] == "hit"
        @computer_health -= 1
      end
      if results[1] == "hit"
        @user_health -= 1
      end

      # Fourth: Puts the results to terminal
      # Re-calculate computer health score. Generate array of ship health, call array.sum 
      #recalculate user health score
        # "Your shot on #{computer's cell} was a #{result-- miss or hit}"
        # "My shot on #{player's cell} was a #{result -- miss or hit}"
        # If a ship was sunk, include "(You or I, as in user or computer) sunk (your or my) #{ship}!"
    # Repeat Loop. Run this on an until or a while loop, that ends when either user or computer health is 0
            #Alternative: instead of using computer_health or user_health, instead use array.all? method to see if all ships sunk. 
            # If all ships are sunk, that would also be end of game. Could eliminate the computer health and user health attributes, tests, and recalculations
            #Coud also add a test into spec like 'can check status of ships', sink a ship, then run expects statements to see status of the ships

    end
  end
  #End Game method
    #If computer health is 0 (or if all computer ships sunk)
        #"You Won!"
    #Else 
      # "I won!"
    #end
    # Returns to main menu (we called it welcome... rename?)
end