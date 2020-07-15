class JourneyLog
  attr_reader :journey_class

  def initialize(journey_class: Journey)
    @journey_class = journey_class.new
    @journeys = []
  end

  def start(entry_station)
    raise('You are already on a journey') if current_journey.entry_station

    @journey_class.start_journey(@entry_station = entry_station)
  end

  def finish(exit_station)
    @journey_class.end_journey(@exit_station = exit_station)
    add_a(@entry_station, @exit_station)
  end

  def history
    @journeys
  end

  private

  def current_journey
    @current_journey ||= @journey_class
  end

  def add_a(entry_station, exit_station)
    # entry_station = entry_station.nil? ? "INCOMPLETE JOURNEY" : entry_station
    @journeys << [entry_station, exit_station]
  end

end

class Journey
  attr_reader :journeys, :current_journey, :entry_station, :exit_station
  PENALTY_FARE = 6

  def initialize
    @in_journey = false
  end

  def start_journey(entry_station)
    @entry_station = entry_station
    @in_journey = true
  end

  def end_journey(exit_station)
    @exit_station = exit_station
    calculate_fare
    reset
  end

  def in_journey?
    @in_journey
  end

  def calculate_fare(fare = 1.00)
    return PENALTY_FARE unless in_journey?

    @fare = fare
  end

  private

  def reset
    @exit_station = nil
    @entry_station = nil
    @penalty = false
    @in_journey = false
  end

end
