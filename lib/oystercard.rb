class Oystercard
  attr_reader :balance, :maximum_balance, :in_use
  MAXIMUM_BALANCE = 90.00
  MINIMUM_BALANCE = 1.00
  def initialize(balance = 0.00, maximum = MAXIMUM_BALANCE)
    raise('Start balance exceeds your maximum') if
        (@balance = balance.round(2)) > (@maximum_balance = maximum.round(2))

    @in_use = false
  end

  def top_up(amount)
    raise("Exceeded maximum balance: #{@maximum_balance}") if
        (@balance += amount) > @maximum_balance

    @balance
  end

  def touch_in
    raise('Insufficient balance') if @balance < MINIMUM_BALANCE

    @in_use = true
  end

  def touch_out(amount = MINIMUM_BALANCE)
    deduct(amount)
    @in_use = false
  end

  def in_journey?
    @in_use
  end

  private

  def deduct(amount)
    raise('Balance is below zero') if (@balance -= amount) < 0.00

    @balance
  end

end

