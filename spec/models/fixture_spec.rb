require 'rails_helper'

describe Fixture do
  describe 'scopes' do
    context 'complete' do
      let!(:should_fail1) { create :fixture, played_at: DateTime.new(2017, 12, 10, 13, 0, 0) }
      let!(:should_fail2) { create :fixture, played_at: DateTime.new(2017, 11, 11, 14, 50, 0) }
      let!(:should_pass1) { create :fixture, played_at: DateTime.new(2017, 11, 11, 13, 0, 0) }
      let!(:should_pass2) { create :fixture, played_at: DateTime.new(2017, 11, 10, 13, 0, 0) }

      before do
        expect(DateTime).to receive(:now).and_return DateTime.new(2017, 11, 11, 13, 0, 0)
      end

      subject { Fixture.complete }

      it 'only returns complete fixtures' do
        expect(subject).to match_array([should_pass1, should_pass2])
      end
    end
  end
end
