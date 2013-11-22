require 'spec_helper'

describe PrtMeasurement do
  context 'validates' do
    it 'presence of either temperature or resistance' do
      expect(build :prt_measurement, temperature: nil, resistance: nil).not_to be_valid
      expect(build :prt_measurement, resistance: 100).to be_valid
      expect(build :prt_measurement, temperature:  0).to be_valid
    end

    it 'temperature range to be within IEC 60751 PRT range' do
      min = Iec60751Prt.range.min
      max = Iec60751Prt.range.max
      expect(build :prt_measurement, temperature: min - 0.01).not_to be_valid
      expect(build :prt_measurement, temperature: min       ).to be_valid
      expect(build :prt_measurement, temperature: max       ).to be_valid
      expect(build :prt_measurement, temperature: max + 0.01).not_to be_valid
    end
  end

  context 'on ambiguous data' do
    it 'prioritizes temperature' do
      m = build :prt_measurement, temperature: 0, resistance: 110
      m.valid?
      expect(m.temperature).to be_within(1e-4).of(0)
      expect(m.resistance ).to be_within(1e-4).of(100)
    end
   end

  context 'associations' do
    it 'belongs to an IEC 60751 PRT' do
      expect(subject).to belong_to :iec60751_prt
    end
  end

  context 'resistance computation' do
    it 'is handled by the prt when getting' do
      m = build :prt_measurement
      expect(m.iec60751_prt).to receive(:r)
      m.resistance
    end
  end

  context 'temperature computation from resistance' do
    it 'is handled by the PRT' do
      m = build :prt_measurement, temperature: nil, resistance: 100
      expect(m.iec60751_prt).to receive(:t90).with(100)
      m.valid?
    end

    it 'sets the temperature' do
      m = build :prt_measurement, temperature: nil, resistance: 110
      m.iec60751_prt.stub(:t90).and_return(25.68)
      m.valid?
      expect(m.temperature).to eq 25.68
    end
  end
end
