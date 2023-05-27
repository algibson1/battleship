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
end
