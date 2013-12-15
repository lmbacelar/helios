require 'spec_helper'

describe PrtMeasurement do
  context 'validates' do
    it 'presence of either temperature or resistance' do
      expect(build :iec60751_prt_measurement, temperature: nil, resistance: nil).not_to be_valid
      expect(build :iec60751_prt_measurement, resistance: 100).to be_valid
      expect(build :iec60751_prt_measurement, temperature:  0).to be_valid
    end

    it 'temperature range to be within Transfer Function range' do
      min = Iec60751Function.new.range.min
      max = Iec60751Function.new.range.max
      expect(build :iec60751_prt_measurement, temperature: min - 0.01).not_to be_valid
      expect(build :iec60751_prt_measurement, temperature: min       ).to be_valid
      expect(build :iec60751_prt_measurement, temperature: max       ).to be_valid
      expect(build :iec60751_prt_measurement, temperature: max + 0.01).not_to be_valid
    end
  end

  context 'on ambiguous data' do
    it 'prioritizes temperature' do
      m = build :iec60751_prt_measurement, temperature: 0, resistance: 110
      m.valid?
      expect(m.temperature).to be_within(1e-4).of(0)
      expect(m.resistance ).to be_within(1e-4).of(100)
    end
   end

  context 'resistance computation' do
    it 'is handled by the Transfer Function when getting' do
      m = build :iec60751_prt_measurement
      expect(m.transfer_function).to receive(:r)
      m.resistance
    end
  end

  context 'temperature computation from resistance' do
    it 'is handled by the Transfer Function' do
      m = build :iec60751_prt_measurement, temperature: nil, resistance: 100
      expect(m.transfer_function).to receive(:t90).with(100)
      m.valid?
    end

    it 'sets the temperature' do
      m = build :iec60751_prt_measurement, temperature: nil, resistance: 110
      m.transfer_function.stub(:t90).and_return(25.68)
      m.valid?
      expect(m.temperature).to eq 25.68
    end
  end
end
