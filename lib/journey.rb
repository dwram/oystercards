class Journey
  attr_reader :journeys, :current_journey, :entry_station
  PENALTY_FARE = 6

  def initialize
    @current_journey = []
    @journeys = Hash.new { |k, v| k[v] = [] }
  end

  def start_journey(entry_station)
    @current_journey << (@entry_station = entry_station)
  end

  def end_journey(exit_station)
    @current_journey << (@exit_station = exit_station)
    @journeys['Trips'] << @current_journey
    @entry_station = nil
  end

  def calculate_fare(fare = 1.00)

  end

  def in_journey?
    @entry_station ? true : false
  end

end
