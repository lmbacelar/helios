require 'spec_helper'

describe Measurement do
  context 'associations' do
    it 'belongs to transfer function' do
      expect(subject).to belong_to :transfer_function
    end
  end

  context 'validations' do
    it 'requires presence of value' do
      expect(subject).to validate_presence_of :value
    end

    it 'requires numericality of value' do
      expect(subject).to validate_numericality_of :value
    end
  end

  context 'scopes' do
    before do
      create :measurement, created_at: '2001-01-01 00:00:00'
      create :measurement, created_at: '2001-01-01 00:01:00'
      create :measurement, created_at: '2001-01-01 00:02:00'
      create :measurement, created_at: '2001-01-01 00:03:00'
    end

    it '#latest expected to show all measurements' do
      expect(Measurement.latest.count).to eq 4
    end

    it '#latest expected to show latest measurements first' do
      expect(Measurement.latest[0].created_at).to be > Measurement.latest[1].created_at
    end

    it '#after(`time`) shows measurements created later than `time`' do
      expect(Measurement.after('2001-01-01 00:01:00').count).to be 2
      expect(Measurement.after('2001-01-01 00:01:00').minimum(:created_at)).to eq '2001-01-01 00:02:00'
      expect(Measurement.after('2001-01-01 00:01:00').maximum(:created_at)).to eq '2001-01-01 00:03:00'
    end

    it '#after(`time`) shows all measurements when `time` is invalid' do
      expect(Measurement.after('some invalid date').count).to be 4
      expect(Measurement.after(nil).count).to be 4
    end

    it '#before(`time`) shows measurements created earlier than `time`' do
      expect(Measurement.before('2001-01-01 00:02:00').count).to be 2
      expect(Measurement.before('2001-01-01 00:02:00').minimum(:created_at)).to eq '2001-01-01 00:00:00'
      expect(Measurement.before('2001-01-01 00:02:00').maximum(:created_at)).to eq '2001-01-01 00:01:00'
    end

    it '#before(`time`) shows all measurements when `time` is invalid' do
      expect(Measurement.before('some invalid date').count).to be 4
      expect(Measurement.before(nil).count).to be 4
    end
  end
end
