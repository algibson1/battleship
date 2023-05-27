class Board
  attr_reader :cells
  def initialize(rows = 4, columns = 4)
    @cells = cell_generator(rows, columns)
  end

  def cell_generator(rows, columns)
    number_range = ("1".."#{columns}").to_a
    letter_range = ("A".."#{(64+rows).chr}").to_a
    numbers = number_range * letter_range.length
    letters = (letter_range * number_range.length).sort
    combos = letters.zip(numbers)
    coordinates = combos.map {|combo| combo.join}
    generated_cells = {}
    coordinates.each do |coordinate|
      generated_cells[coordinate] = Cell.new(coordinate)
    end
    @cells = generated_cells
  end

  def valid_coordinate?(coordinate)
    @cells.keys.include?(coordinate)
  end

  def all_valid_coordinates?(coordinates)
    coordinates.all? {|coordinate| valid_coordinate?(coordinate)}
  end

  def valid_placement?(ship, coordinates)
    all_valid_coordinates?(coordinates) &&
    length_match?(ship, coordinates) && 
    consecutive?(coordinates) && 
    not_diagonal?(coordinates)
  end

  def length_match?(ship, coordinates)
    ship.length == coordinates.length
  end

  def consecutive?(coordinates)
    ordinal_values = []
    coordinates.each do |coordinate|
      ordinal_values << coordinate[0].ord + coordinate[1].to_i
    end
    ordinal_values.each_cons(2).all? { |first_num, next_num| first_num + 1 == next_num}
  end

  def not_diagonal?(coordinates)
    row_letter = coordinates.first[0]
    column_number = coordinates.first[1]
    coordinates.all? do |coordinate|
      coordinate[0] == row_letter || coordinate[1] == column_number
    end
  end

  def place(ship, coordinates)
    if valid_placement?(ship, coordinates)
      coordinates.each do |coordinate|
        @cells[coordinate].place_ship(ship)
      end
    end
  end
end
