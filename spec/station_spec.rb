require_relative '../lib/station'

describe Station do
  it { is_expected.to be_an(Station) }
  it { expect(subject.name).to be_a(String)}
  it { expect(station.zone).to be_an(Integer) }
  it { expect(station.name?).to be_an(String) }
  let(:station) { Station.new }

end