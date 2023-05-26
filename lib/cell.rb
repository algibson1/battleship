class Cell
  attr_reader :coordinate,
              :ship

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fire_status = false
  end

  def empty?
    @ship == nil
  end

  def place_ship(ship)
    @ship = ship
  end

  def fired_upon? 
    @fire_status
  end

  def fire_upon
    @ship&.hit 
    @fire_status = true
  end

  def render(arg = false)
    if @ship&.sunk?
      "X"
    elsif self.fired_upon? && !@ship
      "M"
    elsif @ship && !self.fired_upon? && arg == true
      "S"
    elsif @ship && self.fired_upon? 
      "H"
    else
      "."
    end
  end
end