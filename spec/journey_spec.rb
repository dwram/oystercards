require_relative '../lib/journey'
require_relative '../lib/station'

describe Journey do
  it { is_expected.to be_an Journey }
  it { expect(subject.current_journey.empty?).to be(true) }
  it { expect(subject.journeys.empty?).to be(true) }
end

describe Journey do
  let(:normal_journey) { Journey.new }
  it 'adds a new journey upon ending a journey' do
    station = double('station', Station: Station.new)
    normal_journey.start_journey(station)
    expect{ normal_journey.end_journey(station) }.to change{normal_journey.journeys.size}.by(1)
  end
end