require 'spec_helper'
require 'json'

examples = JSON.parse(File.read('spec/assets/models/iec60751_measurement/examples.json'), symbolize_names: true)

describe Iec60751Measurement do
  context 'validates' do
    it 'presence of either temperature or resistance' do
      expect(Iec60751Measurement.new).not_to be_valid
      expect(Iec60751Measurement.new resistance: 100).to be_valid
      expect(Iec60751Measurement.new temperature:  0).to be_valid
    end

    it 'temperature range to be within -200.10 and 850.10' do
      expect(Iec60751Measurement.new temperature: -200.11).not_to be_valid
      expect(Iec60751Measurement.new temperature: -200.10).to     be_valid
      expect(Iec60751Measurement.new temperature:  850.10).to     be_valid
      expect(Iec60751Measurement.new temperature:  850.11).not_to be_valid
    end
  end

  context 'scopes' do
    before do
      create :iec60751_measurement, temperature: 0, created_at: '2001-01-01 00:00:00'
      create :iec60751_measurement, temperature: 1, created_at: '2001-01-01 00:01:00'
      create :iec60751_measurement, temperature: 2, created_at: '2001-01-01 00:02:00'
      create :iec60751_measurement, temperature: 3, created_at: '2001-01-01 00:03:00'
    end

    it '#latest expected to show all measurements' do
      expect(Iec60751Measurement.latest.count).to eq 4
    end

    it '#latest expected to show latest measurements first' do
      expect(Iec60751Measurement.latest[0].created_at).to be > Iec60751Measurement.latest[1].created_at
    end

    it '#after(`time`) shows measurements created later than `time`' do
      expect(Iec60751Measurement.after('2001-01-01 00:01:00').count).to be 2
      expect(Iec60751Measurement.after('2001-01-01 00:01:00').minimum(:created_at)).to eq '2001-01-01 00:02:00'
      expect(Iec60751Measurement.after('2001-01-01 00:01:00').maximum(:created_at)).to eq '2001-01-01 00:03:00'
    end

    it '#after(`time`) shows all measurements when `time` is invalid' do
      expect(Iec60751Measurement.after('some invalid date').count).to be 4
      expect(Iec60751Measurement.after(nil).count).to be 4
    end


    it '#before(`time`) shows measurements created earlier than `time`' do
      expect(Iec60751Measurement.before('2001-01-01 00:02:00').count).to be 2
      expect(Iec60751Measurement.before('2001-01-01 00:02:00').minimum(:created_at)).to eq '2001-01-01 00:00:00'
      expect(Iec60751Measurement.before('2001-01-01 00:02:00').maximum(:created_at)).to eq '2001-01-01 00:01:00'
    end

    it '#before(`time`) shows all measurements when `time` is invalid' do
      expect(Iec60751Measurement.before('some invalid date').count).to be 4
      expect(Iec60751Measurement.before(nil).count).to be 4
    end
  end

  context 'on ambiguous data' do
    it 'prioritizes temperature' do
      measurement = Iec60751Measurement.new temperature: 0, resistance: 110
      expect(measurement.temperature).to be_within(1e-4).of(0)
      expect(measurement.resistance ).to be_within(1e-4).of(100)
    end
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
