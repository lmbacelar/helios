require 'spec_helper'
require 'json'

examples = JSON.parse(File.read('spec/assets/models/iec60751_measurement/examples.json'), symbolize_names: true)

describe Iec60751Measurement do
  it 'requires presence of either temperature or resistance' do
    expect(Iec60751Measurement.new).not_to be_valid
    expect(Iec60751Measurement.new resistance: 100).to be_valid
    expect(Iec60751Measurement.new temperature:  0).to be_valid
  end

  it 'prioritizes temperature when both temperature and resistance are present' do
    measurement = Iec60751Measurement.new temperature: 0, resistance: 110
    expect(measurement.temperature).to be_within(1e-4).of(0)
    expect(measurement.resistance ).to be_within(1e-4).of(100)
  end

  it 'validates temperature range to be within -200.10 and 850.10' do
    expect(Iec60751Measurement.new temperature: -200.11).not_to be_valid
    expect(Iec60751Measurement.new temperature: -200.10).to     be_valid
    expect(Iec60751Measurement.new temperature:  850.10).to     be_valid
    expect(Iec60751Measurement.new temperature:  850.11).not_to be_valid
  end

  context 'temperature computation' do
    it 'treats complex temperatures as NaN, and considers record invalid' do
      measurement = Iec60751Measurement.new resistance: 1000
      expect(measurement.temperature).to be Float::NAN
      expect(measurement).not_to be_valid
    end

    context 'standard coefficients' do
      examples.each do |example|
        it "yields #{example[:t]} Celius when resistance equals #{example[:r]} Ohm" do
          measurement = Iec60751Measurement.new resistance: example[:r]
          expect(measurement.temperature).to be_within(1e-4).of(example[:t])
        end
      end
    end

    context 'non-standard coefficients' do
      it 'yields 0.0 Celsius when resistance equals 101.0 Ohm on a PRT with r0 = 101.0 Ohm' do
        pending 'now fails but should pass when coefficients are moved to a PRT model'
        measurement = Iec60751Measurement.new resistance: 101.0, r0: 101.0
        expect(measurement.temperature).to be_within(1e-4).of(0)
      end
    end
  end

  context 'resistance computation' do
    context 'standard coefficients' do
      examples.each do |example|
        it "yields #{example[:r]} Ohm when t90 equals #{example[:t]} Celsius" do
          measurement = Iec60751Measurement.new temperature: example[:t]
          expect(measurement.resistance).to be_within(1e-4).of(example[:r])
        end 
      end 
    end

    context 'non-standard coefficients' do
      it 'yields 101.0 Ohm when temperature equals 0.0 Celsius on a PRT with r0 = 101.0 Ohm' do
        measurement = Iec60751Measurement.new temperature: 0.0, r0: 101.0
        expect(measurement.resistance).to be_within(1e-4).of(101)
      end
    end
  end

end
