require_relative './station'
require_relative './journey'

class Oystercard
  attr_reader :balance, :maximum_balance, :journeys, :journey, :entry_station
  MAXIMUM_BALANCE = 90.00
  MINIMUM_BALANCE = 1.00
  def initialize(balance = 0.00, maximum = MAXIMUM_BALANCE)
    raise('Start balance exceeds your maximum') if
        (@balance = balance.round(2)) > (@maximum_balance = maximum.round(2))

    @journey = []
    @journeys = Hash.new { |k, v| k[v] = [] }
  end

  def top_up(amount)
    raise("Exceeded maximum balance: #{@maximum_balance}") if
        (@balance += amount) > @maximum_balance

    @balance
  end

  def touch_in(entry_station = Station.new)
    raise('Insufficient balance') if @balance < MINIMUM_BALANCE
    raise('You have already touched in') if in_journey?

    @journey << (@entry_station = entry_station)
  end

  def touch_out(amount = MINIMUM_BALANCE, exit_station = Station.new)
    raise('You cannot touch_out as you are not on a journey') unless in_journey?

    fare(amount)
    new_journey(exit_station)
    @entry_station = nil
  end

  def in_journey?
    @entry_station ? true : false
  end

  private

  def new_journey(exit_station)
    @journeys['Trips'] << [@entry_station, (@exit_station = exit_station)]
  end

  def fare(amount)
    raise('Balance is below zero') if (@balance -= amount) < 0.00

    @balance
  end

end

