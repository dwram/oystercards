require_relative '../lib/journey'

describe Journey do
  it { is_expected.to be_an Journey }
  it { expect(subject.current_journey.empty?).to be(true) }
  it { expect(subject.journeys.empty?).to be(true) }
end