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
    puts "Welcome to "
    sleep(1)
    puts "__________         __    __  .__           _________.__    .__        "
    puts "\\______   \\_____ _/  |__/  |_|  |   ____  /   _____/|  |__ |__|_____  "
    puts " |    |  _/\\__  \\\\   __\\   __\\  | _/ __ \\ \\_____  \\ |  |  \\|  \\____ \\ "
    puts " |    |   \\ / __ \\|  |  |  | |  |_\\  ___/ /        \\|   Y  \\  |  |_> >"
    puts " |______  /(____  /__|  |__| |____/\\___  >_______  /|___|  /__|   __/ "
    puts "        \\/      \\/                     \\/        \\/      \\/   |__|    "
    `say -r 50 "Battleship"`
    sleep(1)
    puts "Enter p to play. Enter q to quit."
    user_input = gets.chomp
    until user_input.downcase == "p" || user_input.downcase == "q" || user_input.downcase == "play" || user_input.downcase == "quit"
      puts "You had very simple instructions. Just p or q."
      user_input = gets.chomp
    end
    if user_input.downcase == "p"
      sleep(0.8)
      place_computer_ships
      set_up
    elsif user_input.downcase == "q"
      puts "k bye"
    elsif user_input.downcase == "play"
      puts "Really? You only had to write 'p' you know. Fine. Let's play."
      sleep(1)
      place_computer_ships
      set_up
    elsif user_input.downcase == "quit"
      puts "Wow. You only had to write 'q' but sure, rub it in. Leave, then."
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
    #placeholder for take_turn method
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

  #psuedocode below
  # take turn method
    #Loop starts here
    # first: render and puts both computer and player boards
        #player board will render with (true) in order to see the ships
    # Second: Player is prompted to choose a coordinate to fire upon (a cell method)
        #If invalid coordinate selected, will be prompted again
        #cannot choose a cell that has already been fired upon
              # Generate array of already used cells by finding all cells that have a true fired_upon status
                  #Maybe put this outside of the loop, as a collector, which we add to with each turn, instead of generating new array each time through the loop
              # User will get 'invalid coordinate, please choose again' prompt unless they choose a valid coordinate (check against @cells.keys)
              # User may also get alternative message: "You already fired on that coordinate" (check against array of fired upon coordinates)
        # will need to call cell.fire_upon, which changes how the cell will render, and will decrease ship health if a ship is present
        # Re-calculate computer health score. Generate array of ship health, call array.sum 
    # Third: Computer selects a random coordinate to fire upon
        #Need: array of valid coordinates, then call #select to choose random cell
              # Generate valid_cells array by finding all cells that are not fired upon yet
        # call #fire_upon on the randomly selected cell
        #recalculate user health score
    # Fourth: Puts the results to terminal
        # "Your shot on #{computer's cell} was a #{result-- miss or hit}"
        # "My shot on #{player's cell} was a #{result -- miss or hit}"
        # If a ship was sunk, include "(You or I, as in user or computer) sunk (your or my) #{ship}!"
    # Repeat Loop. Run this on an until or a while loop, that ends when either user or computer health is 0
            #Alternative: instead of using computer_health or user_health, instead use array.all? method to see if all ships sunk. 
            # If all ships are sunk, that would also be end of game. Could eliminate the computer health and user health attributes, tests, and recalculations
            #Coud also add a test into spec like 'can check status of ships', sink a ship, then run expects statements to see status of the ships


  #End Game method
    #If computer health is 0 (or if all computer ships sunk)
        #"You Won!"
    #Else 
      # "I won!"
    #end
    # Returns to main menu (we called it welcome... rename?)
end