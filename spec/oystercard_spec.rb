# frozen_string_literal: true
require_relative '../lib/oystercard'

describe Oystercard do
  it { is_expected.to be_an Oystercard }
  it { is_expected.to respond_to :top_up }
  it { expect(subject.balance).to be_an(Float) }
  it { expect(Oystercard::MAXIMUM_BALANCE).to be_an(Float) }
  it { expect(Oystercard::MINIMUM_BALANCE).to be_an(Float) }
  it { expect(subject.maximum_balance).to be_an(Float) }
  it { expect(subject.balance).to be_an(Float) }
  it { expect(subject.journey).to be_truthy }
  it { expect(subject.journey).to be_an(Journey) }
  it { expect(subject.journeys.empty?).to be(true) }
end

describe Oystercard do
  let(:card) { Oystercard.new }
  let(:low_card) { Oystercard.new(10)}
  let(:sufficient_card) { Oystercard.new(70) }
  let(:poverty_card) { Oystercard.new(0.99) }
  let(:station) { double(:station) }

  it 'Adds an amount to the balance' do
    expect(card.top_up(25)).to eq(card.balance)
  end
  it 'Raises an error upon exceeding maximum via initialisation' do
    expect { Oystercard.new(100, 50) }.to raise_error('Start balance exceeds your maximum')
  end
  it 'Raises an error upon exceeding maximum via top-up' do
    expect { card.top_up(100) }.to raise_error("Exceeded maximum balance: #{card.maximum_balance}")
  end
  it 'Deducts £10 from the balance after topping up £10' do
    low_card.touch_in
    expect { low_card.touch_out(10) }.to change { low_card.balance }.by(-10.00)
  end
  it 'Raises an error when there is not enough money' do
    low_card.touch_in
    expect { low_card.touch_out(11) }.to raise_error('Balance is below zero')
  end
  it 'Touch in with with > £1.00 balance and set card to in_journey' do
    sufficient_card.touch_in
    expect(sufficient_card.journey.in_journey?).to eq(true)
  end
  it 'Touch out and deduce balance by £1.00 and sets card to not in_journey' do
    sufficient_card.touch_in
    expect { sufficient_card.touch_out }.to change { sufficient_card.balance }.by(-Oystercard::MINIMUM_BALANCE)
    expect( sufficient_card.journey.in_journey?).to eq(false)
  end
  it 'Card is in_journey when in use' do
    card = Oystercard.new(1.99)
    expect{ card.touch_in }.to change{ card.journey.in_journey? }.to true
  end
  it 'Raises error when balance is under £1.00' do
    expect { poverty_card.touch_in }.to raise_error('Insufficient balance')
  end
  it 'Issues penalty fare after touching in without touching out' do
    expect { 2.times{sufficient_card.touch_in} }.to change{sufficient_card.balance}.by(-Journey::PENALTY_FARE)
  end
  it 'adds a station to journeys upon touch-in' do
    expect{ sufficient_card.touch_in(station) }.to change{ sufficient_card.journey.current_journey.size}.by(1)
    expect(sufficient_card.journey.current_journey).to include(station)
  end
  it 'removes the entry_station value upon touch-out' do
    sufficient_card.touch_in(station)
    expect{ sufficient_card.touch_out }.to change{ sufficient_card.journey.entry_station }.to(nil)
  end
  it 'adds a new journey with entry and exit station value upon touch-out' do
    sufficient_card.touch_in
    expect{ sufficient_card.touch_out }.to change{ sufficient_card.journey.journeys.size }.by(1)
  end

end
