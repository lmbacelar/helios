require 'spec_helper'
require 'json'

examples = JSON.parse(File.read('spec/assets/models/iec60751_prt/examples.json'), symbolize_names: true)

describe Iec60751Prt do
  context 'includes module' do
    it 'RetryMethods' do
      expect(Iec60751Prt.included_modules).to include RetryMethods
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
      expect(subject).to have_many(:prt_measurements).dependent(:destroy)
    end
  end

  context 'resistance computation' do
    context 'standard coefficients' do
      let(:prt) { build :iec60751_prt }
      examples.each do |example|
        it "yields #{example[:r]} Ohm when t90 equals #{example[:t90]} Celsius" do
          expect(prt.r example[:t90]).to be_within(1e-4).of(example[:r])
        end 
      end 
    end

    context 'non-standard coefficients' do
      let(:prt) { build :iec60751_prt, r0: 101 }
      it 'yields 101.0 Ohm when temperature equals 0.0 Celsius on a PRT with r0 = 101.0 Ohm' do
        expect(prt.r 0).to be_within(1e-4).of(101)
      end
    end
  end

  context 'temperature computation' do
    it 'yields complex temperatures as NaN' do
      expect(Iec60751Prt.new.t90 1000).to be Float::NAN
    end

    context 'standard coefficients' do
      let(:prt) { build :iec60751_prt }
      examples.each do |example|
        it "yields #{example[:t90]} Celius when resistance equals #{example[:r]} Ohm" do
          expect(prt.t90 example[:r]).to be_within(1e-4).of(example[:t90])
        end
      end
    end

    context 'non-standard coefficients' do
      it 'yields 0.0 Celsius when resistance equals 101.0 Ohm on a PRT with r0 = 101.0 Ohm' do
        expect(Iec60751Prt.new(r0: 101).t90 101).to be_within(1e-4).of(0)
      end
    end
  end

end
