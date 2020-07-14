class Station
  attr_reader :zone, :name
  STATIONS = { 1 => 'Baker Street', 2 => 'Greenwich', 3 => 'Brent Cross', 4 => 'Kew Gardens', 5 => 'Canons Park' }
  def initialize
    @name = name?
    @zone = STATIONS.key(@name)
  end

  def name?
    STATIONS[(1..5).to_a.sample]
  end

end