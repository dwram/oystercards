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
  it { expect(subject.journey).to all(Station) }
end

describe Oystercard do
  let(:card) { Oystercard.new }
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
  it 'Deducts £10 from the balance' do
    card.top_up(10)
    expect { card.touch_out(10) }.to change { card.balance }.by(-10.00)
  end
  it 'Raises an error when there is not enough money' do
    expect { card.touch_out(10) }.to raise_error('Balance is below zero')
  end
  it 'Touch in with with > £1.00 balance and set card to in_use' do
    sufficient_card.touch_in
    expect(sufficient_card.in_use).to eq(true)
  end
  it 'Touch out and deduce balance by £1.00 and sets card to not in_use' do
    expect { sufficient_card.touch_out }.to change { sufficient_card.balance }.by(-1.00)
    expect(sufficient_card.in_use).to eq(false)
  end
  it 'Card is in_journey when in use' do
    card = Oystercard.new(1.99)
    expect{ card.touch_in }.to change{ card.in_journey? }.to true
  end
  it 'Does not allow touch in when balance is under £1.00' do
    expect { poverty_card.touch_in }.to raise_error('Insufficient balance')
  end
  it 'adds a station to journeys upon touch-in' do
    expect{ sufficient_card.touch_in(station) }.to change{ sufficient_card.journey.size}.by(1)
    expect(sufficient_card.journey).to include(station)
  end
  it 'removes the entry_station value upon touch-out' do
    sufficient_card.touch_in(station)
    expect{ sufficient_card.touch_out }.to change{ sufficient_card.entry_station }.to(nil)
  end
  it 'adds a new journey with entry and exit station value upon touch-out' do
    pending("")
    expect{ sufficient_card.touch_out }.to change{ sufficient_card.journeys.size }.by(1)
  end
end
