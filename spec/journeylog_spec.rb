require_relative '../lib/journey'

describe JourneyLog do
  it { is_expected.to respond_to(:start) }
  it { is_expected.to respond_to(:finish) }
  it { is_expected.to respond_to(:history) }
end

describe JourneyLog do
  let(:journey_class) { double :journey_class, new: Journey }
  describe '#start' do
    it 'starts a journey' do
      expect(journey_class).to receive(:new).and_return Journey
      journey_class.new
    end
  end
end