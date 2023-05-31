class Battle
  attr_reader :computer_health,
              :user_health,
              :computer_board,
              :user_board,
              :computer_ships,
              :user_ships

  def initialize
    @computer_health = 0
    @user_health = 0
    @computer_board = Board.new
    @user_board = Board.new
    @computer_ships = [Ship.new("Cruiser", 3), Ship.new("Submarine", 2)]
    @user_ships = [Ship.new("Cruiser", 3), Ship.new("Submarine", 2)]
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
      puts "Awesome, let's play!"
      play_game
    elsif user_input.downcase == "q"
      puts "k bye"
    elsif user_input.downcase == "play"
      puts "Really? You only had to write 'p' you know. Fine. Let's play."
      play_game
    elsif user_input.downcase == "quit"
      puts "Wow. You only had to write 'q' but sure, rub it in. Leave, then."
    end
  end
  
  def play_game
    place_computer_ships
    sleep(1)
    set_up
    user_ship_placement
    take_turn
    end_game
    reset
    welcome
  end

  def generate_placement(ship)
    all_possible_sets = @computer_board.cells.keys.permutation(ship.length).to_a
    valid_placements = all_possible_sets.find_all do |coordinate_set|
      @computer_board.valid_placement?(ship, coordinate_set)
    end
    valid_placements.sample
  end

  def place_computer_ships
    @computer_ships.each do |ship|
      @computer_board.place(ship, generate_placement(ship))
      @computer_health += ship.health
    end
  end

  def set_up
    puts "I have laid out my ships on the grid."
    sleep(0.8)
    puts "You now need to lay out your ships."
    sleep(0.8)
    "The Cruiser is three units long and the Submarine is two units long."
    sleep(0.8)
  end

  def user_ship_placement
    @user_ships.each do |ship|
      puts @user_board.render(true)
      sleep(0.5)
      puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"
      coordinates = gets.chomp.split
      until @user_board.valid_placement?(ship, coordinates)
        puts "Those are invalid coordinates. Please try again."
        coordinates = gets.chomp.split
      end
      @user_board.place(ship, coordinates)
      @user_health += ship.health
      sleep(0.5)
    end
    puts "Looks good! Let's play!"
    sleep(0.8)
  end

  def turn_setup
    puts "==========COMPUTER BOARD=========="
    puts @computer_board.render
    puts "==========PLAYER BOARD=========="
    puts @user_board.render(true)
    sleep(0.8)
    puts "Enter the coordinate for your shot:"
  end

  def fire_player_shot(pending_user_shot)
    user_shot = pending_user_shot
    until @computer_board.valid_coordinate?(user_shot) && !@computer_board.cells[user_shot].fired_upon?
      if !@computer_board.valid_coordinate?(user_shot)
        puts "Please enter a valid coordinate"
      else
        puts "You already shot that square! Pick another:"
      end
      user_shot = gets.chomp
    end
    @computer_board.cells[user_shot].fire_upon
    user_shot
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

  def display_results(user_shot, computer_shot, results)
    sleep(0.8)
    puts "Your shot on #{user_shot} was a #{results[0]}."
    sleep(0.8)
    puts "My shot on #{computer_shot} was a #{results[1]}."
    sleep(0.8)
    puts "---"
    sleep(0.3)
    if @user_board.cells[computer_shot].ship&.sunk?
      puts "Get SUNK! I sank your #{@user_board.cells[computer_shot].ship.name}!"
      sleep(0.8)
    end
    if @computer_board.cells[user_shot].ship&.sunk?
      puts "Oh no, you sank my #{@computer_board.cells[user_shot].ship.name}!"
      sleep(0.8)
    end
  end

  def take_turn
    until @user_health == 0 || @computer_health == 0
      sleep(0.8)
      turn_setup
      pending_user_shot = gets.chomp
      user_shot = fire_player_shot(pending_user_shot)
      computer_shot = generate_computer_shot
      @user_board.cells[computer_shot].fire_upon
      results = calculate_results(user_shot, computer_shot)
      display_results(user_shot, computer_shot, results)
      if results[0] == "hit"
        @computer_health -= 1
      end
      if results[1] == "hit"
        @user_health -= 1
      end
    end
  end

  def end_game
    sleep(1)
    if @computer_health == 0
      puts "You won! Darn..."
      puts "---------"
    elsif @user_health == 0
      puts "I won! HAHA! Get SUNK!"
      puts "---------"
    else 
      puts "....Well. I guess we destroyed each other. Good game."
      puts "---------"
    end
    sleep(2)
    puts "I hope you will play again!"
    puts "----------"
    sleep(2)
  end

  def reset
    @computer_health = 0
    @user_health = 0
    @computer_board = Board.new
    @user_board = Board.new
    @computer_ships = [Ship.new("Cruiser", 3), Ship.new("Submarine", 2)]
    @user_ships = [Ship.new("Cruiser", 3), Ship.new("Submarine", 2)]
  end
end