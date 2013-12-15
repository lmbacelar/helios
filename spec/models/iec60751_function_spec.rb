require 'spec_helper'
require 'json'

examples = JSON.parse(File.read('spec/assets/models/iec60751_function/examples.json'), symbolize_names: true)

describe Iec60751Function do
  context 'includes module' do
    it 'RetryMethods' do
      expect(Iec60751Function.included_modules).to include RetryMethods
    end
  end

  context 'validations' do
    it 'requires name to be present' do
      expect(subject).to validate_presence_of :name
    end

    it 'requires name to be unique' do
      expect(subject).to validate_uniqueness_of :name
    end
  end

  context 'associations' do
    it 'has many PRT Measurements' do
      expect(subject).to have_many(:measurements).dependent(:destroy).class_name('PrtMeasurement')
    end
  end

  context 'resistance computation' do
    context 'standard coefficients' do
      let(:function) { build :iec60751_function }
      examples.each do |example|
        it "yields #{example[:r]} Ohm when t90 equals #{example[:t90]} Celsius" do
          expect(function.r example[:t90]).to be_within(1e-4).of(example[:r])
        end 
      end 
    end

    context 'non-standard coefficients' do
      let(:function) { build :iec60751_function, r0: 101 }
      it 'yields 101.0 Ohm when temperature equals 0.0 Celsius on a FUNCTION with r0 = 101.0 Ohm' do
        expect(function.r 0).to be_within(1e-4).of(101)
      end
    end
  end

  context 'temperature computation' do
    it 'yields complex temperatures as NaN' do
      expect(Iec60751Function.new.t90 1000).to be Float::NAN
    end

    context 'standard coefficients' do
      let(:function) { build :iec60751_function }
      examples.each do |example|
        it "yields #{example[:t90]} Celius when resistance equals #{example[:r]} Ohm" do
          expect(function.t90 example[:r]).to be_within(1e-4).of(example[:t90])
        end
      end
    end

    context 'non-standard coefficients' do
      let(:function) { build :iec60751_function, r0: 101 }
      it 'yields 0.0 Celsius when resistance equals 101.0 Ohm on a FUNCTION with r0 = 101.0 Ohm' do
        expect(function.t90 101).to be_within(1e-4).of(0)
      end
    end
  end

  context 'range function' do
    it 'returns -200.10..850.10' do
      expect(Iec60751Function.new.range).to eq (-200.10..850.10)
    end
  end
end
