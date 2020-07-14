class Journey
  attr_reader :journeys, :journey
  PENALTY_FARE = 6

  def initialize
    @journey = []
    @journeys = Hash.new { |k, v| k[v] = [] }
  end

  def start_journey(entry_station)
    @journey << (@entry_station = entry_station)
  end

  def end_journey(exit_station)
    @journeys['Trips'] << [@entry_station, (@exit_station = exit_station)]
    @entry_station = nil
  end

  def calculate_fare(fare = 1.00)

  end

  def is_complete?
    @entry_station ? true : false
  end

end
