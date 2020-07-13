# frozen_string_literal: true

require_relative '../lib/oystercard'

describe Oystercard do
  it { is_expected.to be_an Oystercard }
  it { is_expected.to respond_to :top_up }
  it { expect(subject.balance).to be_an(Float) }
  it { expect(Oystercard::MAXIMUM_BALANCE).to be_an(Float) }
  it { expect(Oystercard::MINIMUM_BALANCE).to be_an(Float) }
  it { expect(subject.maximum_balance).to be_an(Float) }
end

describe Oystercard do
  let(:card) { Oystercard.new }
  it 'Adds an amount to the balance' do
    expect(card.top_up(25)).to eq(card.balance)
  end
  it 'Raises an error upon exceeding maximum via initialisation' do
    expect { Oystercard.new(100, 50) }.to raise_error('Start balance exceeds your maximum')
  end
  it 'Raises an error upon exceeding maximum via top-up' do
    expect { card.top_up(100) }.to raise_error("Exceeded maximum balance: #{card.maximum_balance}")
  end
  it 'Deducts £10 from the balance' do
    card.top_up(10)
    expect { card.touch_out(10) }.to change { card.balance }.by(-10.00)
  end
  it 'Raises an error when there is not enough money' do
    expect { card.touch_out(10) }.to raise_error('Balance is below zero')
  end
  it 'Touch in with with £1.00 balance and set card to in_use' do
    card = Oystercard.new(1.00)
    card.touch_in
    expect(card.in_use).to eq(true)
  end
  it 'Touch out and deduce balance by £1.00 and sets card to not in_use' do
    card = Oystercard.new(5.00)
    expect { card.touch_out }.to change { card.balance }.by(-1.00)
    expect(card.in_use).to eq(false)
  end
end

describe Oystercard do
  it 'Card is in_journey when in use' do
    card = Oystercard.new(1.99)
    expect{ card.touch_in }.to change{ card.in_journey? }.to true
  end
  it 'Does not allow touch in when balance is under £1.00' do
    card = Oystercard.new(0.99)
    expect { card.touch_in }.to raise_error('Insufficient balance')
  end
end
