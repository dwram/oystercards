require_relative './station'
require_relative './journey'

class Oystercard
  attr_reader :balance, :maximum_balance, :entry_station

  MAXIMUM_BALANCE = 90.00
  MINIMUM_BALANCE = 1.00

  def initialize(balance = 0.00, maximum = MAXIMUM_BALANCE, journeys_class: JourneyLog)
    raise('Start balance exceeds your maximum') if
        (@balance = balance.round(2)) > (@maximum_balance = maximum.round(2))

    @journeys_class = journeys_class.new
  end

  def top_up(amount)
    raise("Exceeded maximum balance: #{@maximum_balance}") if
        (@balance += amount) > @maximum_balance

    @balance
  end

  def touch_in(entry_station = Station.new)
    raise('Insufficient balance') if @balance < MINIMUM_BALANCE

    @journeys_class.start(entry_station)
  end

  def touch_out(exit_station = Station.new, amount = @journeys_class.send(:current_journey).calculate_fare)
    @journeys_class.finish(exit_station)
    fare(amount)
  end

  def journeys
    @journeys = @journeys_class.history
    @journeys.dup
  end

  private

  def fare(amount = MINIMUM_BALANCE)
    raise('Balance is below zero') if (@balance -= amount) < 0.00

    @balance
  end



end

