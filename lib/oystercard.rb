require_relative './station'

class Oystercard
  attr_reader :balance, :maximum_balance, :in_use, :journey, :entry_station
  MAXIMUM_BALANCE = 90.00
  MINIMUM_BALANCE = 1.00
  def initialize(balance = 0.00, maximum = MAXIMUM_BALANCE)
    raise('Start balance exceeds your maximum') if
        (@balance = balance.round(2)) > (@maximum_balance = maximum.round(2))

    @in_use = false
    @journey = []
  end

  def top_up(amount)
    raise("Exceeded maximum balance: #{@maximum_balance}") if
        (@balance += amount) > @maximum_balance

    @balance
  end

  def touch_in(station = Station.new)
    raise('Insufficient balance') if @balance < MINIMUM_BALANCE

    @journey << (@entry_station = station)
    @in_use = true
  end

  def touch_out(amount = MINIMUM_BALANCE)
    deduct(amount)
    @entry_station = nil
    @in_use = false
  end

  def in_journey?
    @entry_station ? true : false
  end

  private

  def deduct(amount)
    raise('Balance is below zero') if (@balance -= amount) < 0.00

    @balance
  end

end

