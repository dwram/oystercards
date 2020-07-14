require_relative './station'
require_relative './journey'

class Oystercard
  attr_reader :balance, :maximum_balance, :journeys, :journey, :entry_station, :card
  MAXIMUM_BALANCE = 90.00
  MINIMUM_BALANCE = 1.00

  def initialize(balance = 0.00, maximum = MAXIMUM_BALANCE)
    raise('Start balance exceeds your maximum') if
        (@balance = balance.round(2)) > (@maximum_balance = maximum.round(2))

    @journey = Journey.new
    @journeys = @journey.journeys
  end

  def top_up(amount)
    raise("Exceeded maximum balance: #{@maximum_balance}") if
        (@balance += amount) > @maximum_balance

    @balance
  end

  def touch_in(entry_station = Station.new)
    raise('Insufficient balance') if @balance < MINIMUM_BALANCE

    @balance -= Journey::PENALTY_FARE if @journey.in_journey? # PENALTY FARE
    @journey.start_journey(entry_station)
  end

  def touch_out(amount = MINIMUM_BALANCE, exit_station = Station.new)
    raise('You cannot touch_out as you are not on a journey') unless @journey.in_journey?

    fare(amount)
    @journey.end_journey(exit_station)
  end

  private

  def fare(amount = @journey.calculate_fare)
    raise('Balance is below zero') if (@balance -= amount) < 0.00

    @balance
  end

end

