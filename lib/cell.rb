class Cell
  attr_reader :coordinate,
              :ship

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end

  def empty?
    @ship == nil
  end

  def place_ship(ship)
    @ship = ship
  end

  def fired_upon? 
    @fired_upon
  end

  def fire_upon
    @ship&.hit 
    @fired_upon = true
  end

  def render(show_ships = false)
    if @ship&.sunk?
      "X"
    elsif fired_upon? && !@ship
      "M"
    elsif @ship && !fired_upon? && show_ships == true
      "S"
    elsif @ship && fired_upon? 
      "H"
    else
      "."
    end
  end
end