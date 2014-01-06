require 'spec_helper'
# require 'json'

describe Iec60584Function do
  context 'inherits from' do
    it 'Transfer Function' do
      expect(Iec60584Function.superclass).to be TransferFunction
    end
  end

  context 'includes module' do
    it 'RetryMethods' do
      expect(Iec60584Function.included_modules).to include RetryMethods
    end
  end

  context 'defaults' do
    let(:function) { create :iec60584_function, type: 'K' }
    it 'correction coefficients to 0.0' do
      expect(function.a3).to eq 0
      expect(function.a2).to eq 0
      expect(function.a1).to eq 0
      expect(function.a0).to eq 0
    end
  end

  context 'validations' do
    let(:function) { create :iec60584_function, type: 'K'}
    it 'requires name to be present' do
      expect(function).to validate_presence_of :name
    end

    it 'requires name to be unique' do
      expect(function).to validate_uniqueness_of :name
    end

    it 'requires type to be present' do
      expect(function).to validate_presence_of :type
    end

    it 'requires type to included in TYPES' do
      expect(function).to ensure_inclusion_of(:type).in_array(Iec60584Function::TYPES)
    end
  end

  # TODO:
  #
  # context 'associations' do
  #   it 'has many PRT Measurements' do
  #     expect(subject).to have_many(:measurements).dependent(:destroy).class_name('PrtMeasurement')
  #   end
  # end

  context 'reference functions' do
    context 'direct (temperature => emf)' do
      Iec60584Function::TYPES.each do |type|
        context "on a type #{type} thermocouple" do
          let(:function) { create :iec60584_function, type: type }

          examples = JSON.parse(File.read("spec/assets/models/iec60584_function/examples_#{type.downcase}.json"),
                                symbolize_names: true)
          examples.each do |example|
            it "yields #{example[:emf]} mV when t90 equals #{example[:t90]} Celsius" do
              expect(function.emfr example[:t90]).to be_within(0.001).of(example[:emf])
            end

          end

          it 'returns nil when out of range' do
            expect(function.emfr examples.first[:t90] - 1).to be_nil
            expect(function.emfr examples.last[:t90]  + 1).to be_nil
          end
        end
      end
    end

    context 'inverse (emf => temperature)' do
      #
      # TODO: 
      #   1. Find approximation functions that can invert type C TC's
      #   2. Find approximation functions that can invert type E, N, K, T TC's down to -270 ºC
      #
      Iec60584Function::TYPES.each do |type|
        unless type == 'C'
          context "on a type #{type} thermocouple" do
            let(:function) { build :iec60584_function, type: type }

            examples = JSON.parse(File.read("spec/assets/models/iec60584_function/examples_#{type.downcase}.json"),
                                  symbolize_names: true)
            examples.each do |example|
              unless example[:t90] == -270.0 
                it "should be inverse of direct function for #{example[:t90]} Celsius" do
                  expect(function.t90(function.emfr(example[:t90]))).to be_within(0.001).of(example[:t90])
                end
              end
            end

            it 'returns nil when out of range' do
              expect(function.t90 examples.first[:emf] - 0.005).to be_nil
              expect(function.t90 examples.last[:emf]  + 0.005).to be_nil
            end
          end
        end
      end
    end
  end

  context 'temperature function' do
    npl_tc = JSON.parse(File.read('spec/assets/models/iec60584_function/npl_tc.json'), symbolize_names: true)
    let(:function) { create :iec60584_function, type: npl_tc[:type],
                                                a3: npl_tc[:a3], a2: npl_tc[:a2], a1: npl_tc[:a1], a0: npl_tc[:a0] }
    npl_tc_examples = JSON.parse(File.read('spec/assets/models/iec60584_function/npl_tc_examples.json'), symbolize_names: true)
    npl_tc_examples.each do |example|
      it "complies with NPL cert. 09/13/A, #{example[:t90]} Celsius" do
        expect(function.t90 example[:emf]).to be_within(0.001).of(example[:t90])
      end
    end
  end

  context 'emf function' do
    it 'implements #emf function placeholder' do
      expect(Iec60584Function.new.emf 0).to be_nil
    end
  end

  context 'range function' do
    examples = JSON.parse(File.read("spec/assets/models/iec60584_function/ranges.json"), symbolize_names: true)
    examples.each do |example|
      context "on a type #{example[:type]} thermocouple" do
        let(:function) { create :iec60584_function, type: example[:type]}

        it 'returns -200.10..850.10' do
          expect(function.range).to eq (example[:t_min]..example[:t_max])
        end
      end
    end
  end
end
