require 'spec_helper'

describe AdminStatsPresenter do
  describe '#sign_ups_by_date' do
    before do
      @profile = FactoryGirl.build(:profile, :created_at => Time.now)
      Profile.stub(:where).and_return([@profile])
    end

    it 'returns a hash with dates as keys and counts as values' do
      counts = subject.sign_ups_by_date
      expect(counts.keys.map(&:to_s)).to have(30).dates
      expect(counts.keys[-2..-1]).to eq([
        (Time.zone.now-1.day).to_date,
        Time.zone.now.to_date
      ])
      expect(counts.values[-2..-1]).to eq([[], [@profile]])
    end
  end
end
