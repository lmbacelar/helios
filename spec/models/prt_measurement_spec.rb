require 'spec_helper'

describe PrtMeasurement do
  context 'validates' do
    it 'presence of PRT' do
      expect(subject).to validate_presence_of :iec60751_prt
    end

    it 'presence of either temperature or resistance' do
      expect(build :prt_measurement, temperature: nil, resistance: nil).not_to be_valid
      expect(build :prt_measurement, resistance: 100).to be_valid
      expect(build :prt_measurement, temperature:  0).to be_valid
    end

    it 'temperature range to be within IEC 60751 PRT range' do
      min = Iec60751Prt::RANGE.min
      max = Iec60751Prt::RANGE.max
      expect(build :prt_measurement, temperature: min - 0.01).not_to be_valid
      expect(build :prt_measurement, temperature: min       ).to be_valid
      expect(build :prt_measurement, temperature: max       ).to be_valid
      expect(build :prt_measurement, temperature: max + 0.01).not_to be_valid
    end
  end

  context 'on ambiguous data' do
    it 'prioritizes temperature' do
      m = create :prt_measurement, temperature: 0, resistance: 110
      m.save
      expect(m.temperature).to be_within(1e-4).of(0)
      expect(m.resistance ).to be_within(1e-4).of(100)
    end
   end

  context 'associations' do
    it 'belongs to an IEC 60751 PRT' do
      expect(subject).to belong_to :iec60751_prt
    end
  end

  context 'scopes' do
    before do
      create :prt_measurement, temperature: 0, created_at: '2001-01-01 00:00:00'
      create :prt_measurement, temperature: 1, created_at: '2001-01-01 00:01:00'
      create :prt_measurement, temperature: 2, created_at: '2001-01-01 00:02:00'
      create :prt_measurement, temperature: 3, created_at: '2001-01-01 00:03:00'
    end

    it '#latest expected to show all measurements' do
      expect(PrtMeasurement.latest.count).to eq 4
    end

    it '#latest expected to show latest measurements first' do
      expect(PrtMeasurement.latest[0].created_at).to be > PrtMeasurement.latest[1].created_at
    end

    it '#after(`time`) shows measurements created later than `time`' do
      expect(PrtMeasurement.after('2001-01-01 00:01:00').count).to be 2
      expect(PrtMeasurement.after('2001-01-01 00:01:00').minimum(:created_at)).to eq '2001-01-01 00:02:00'
      expect(PrtMeasurement.after('2001-01-01 00:01:00').maximum(:created_at)).to eq '2001-01-01 00:03:00'
    end

    it '#after(`time`) shows all measurements when `time` is invalid' do
      expect(PrtMeasurement.after('some invalid date').count).to be 4
      expect(PrtMeasurement.after(nil).count).to be 4
    end

    it '#before(`time`) shows measurements created earlier than `time`' do
      expect(PrtMeasurement.before('2001-01-01 00:02:00').count).to be 2
      expect(PrtMeasurement.before('2001-01-01 00:02:00').minimum(:created_at)).to eq '2001-01-01 00:00:00'
      expect(PrtMeasurement.before('2001-01-01 00:02:00').maximum(:created_at)).to eq '2001-01-01 00:01:00'
    end

    it '#before(`time`) shows all measurements when `time` is invalid' do
      expect(PrtMeasurement.before('some invalid date').count).to be 4
      expect(PrtMeasurement.before(nil).count).to be 4
    end
  end

  context 'resistance computation' do
    it 'is handled by the prt when getting' do
      m = create :prt_measurement
      expect(m.iec60751_prt).to receive(:r)
      m.resistance
    end
  end

  context 'temperature computation from resistance' do
    it 'is handled by the PRT' do
      m = build :prt_measurement, temperature: nil, resistance: 100
      expect(m.iec60751_prt).to receive(:t90).with(100)
      m.save
    end

    it 'sets the temperature' do
      m = build :prt_measurement, temperature: nil, resistance: 110
      m.iec60751_prt.stub(:t90).and_return(25.68)
      m.save
      expect(m.temperature).to eq 25.68
    end
  end
end
