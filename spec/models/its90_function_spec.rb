require 'spec_helper'
require 'json'

fixed_point_examples = 
  JSON.parse( File.read('spec/assets/models/its90_function/fp_examples.json'), symbolize_names: true)

describe Its90Function do
  context 'inherits from' do
    it 'Transfer Function' do
      expect(Its90Function.superclass).to be TransferFunction
    end
  end

  context 'includes module' do
    it 'RetryMethods' do
      expect(Its90Function.included_modules).to include RetryMethods
    end
  end

  context 'defaults' do
    let(:function) { create :its90_function, sub_range: 4 }
    it 'Rtpw to 25 Ohm' do
      expect(function.rtpw).to be_within(1e-9).of(25)
    end

    it 'all other coefficients to 0.0' do
      expect(function.a   ).to eq 0
      expect(function.b   ).to eq 0
      expect(function.c   ).to eq 0
      expect(function.d   ).to eq 0
      expect(function.w660).to eq 0
      expect(function.c1  ).to eq 0
      expect(function.c2  ).to eq 0
      expect(function.c3  ).to eq 0
      expect(function.c4  ).to eq 0
      expect(function.c5  ).to eq 0
    end
  end

  context 'validations' do
    let(:function) { create :its90_function, sub_range: 4 }
    it 'requires name to be present' do
      expect(function).to validate_presence_of :name
    end

    it 'requires name to be unique' do
      expect(function).to validate_uniqueness_of :name
    end

    it 'requires sub_range to be present' do
      expect(function).to validate_presence_of :sub_range
    end

    it 'requires sub_range to included in SUB_RANGES' do
      expect(function).to ensure_inclusion_of(:sub_range).in_range(Its90Function::SUB_RANGES)
    end
  end

  context 'associations' do
    it 'has many PRT Measurements' do
      expect(subject).to have_many(:measurements).dependent(:destroy).class_name('PrtMeasurement')
    end
  end

  context 'reference funtions' do
    context 'wr computation' do
      fixed_point_examples.each do |example|
        it "complies on #{example[:fixed_point]} fixed point" do
          expect(Its90Function.wr example[:t90]).to be_within(1e-8).of(example[:wr])
        end 
      end 

      it 'returns nil when out of range' do
        expect(Its90Function.wr(-259.50)).to be_nil
        expect(Its90Function.wr( 961.90)).to be_nil
      end 
    end 

    context 't90r computation' do
      fixed_point_examples.each do |example|
        it "complies on #{example[:fixed_point]} fixed point" do
          expect(Its90Function.t90r example[:wr]).to be_within(0.00013).of(example[:t90])
        end
      end

      it 'returns nil when out of range' do
        expect(Its90Function.t90r 0.001).to be_nil
        expect(Its90Function.t90r 4.290).to be_nil
      end
    end
  end

  context 'deviation functions' do
    context 'wdev computation' do
      range4_examples = 
        JSON.parse(File.read('spec/assets/models/its90_function/r4_examples.json'), symbolize_names: true)
      range4_sprt = 
        JSON.parse(File.read('spec/assets/models/its90_function/r4_sprt.json'), symbolize_names: true)
      let(:function4) { create :its90_function, sub_range: 4, a: range4_sprt[:a], b:range4_sprt[:b] }
      range4_examples.each do |example|
        it "complies with NIST SP250-81 sample on range 4, #{example[:t90]} Celsius" do
          expect(function4.wdev example[:t90]).to be_within(1e-8).of(example[:wdev])
        end
      end
      
      range6_examples =
        JSON.parse(File.read('spec/assets/models/its90_function/r6_examples.json'), symbolize_names: true)
      range6_sprt = 
        JSON.parse(File.read('spec/assets/models/its90_function/r6_sprt.json'), symbolize_names: true)
      let(:function6) { create :its90_function, sub_range: 6, a: range6_sprt[:a], b:range6_sprt[:b], c:range6_sprt[:c] }
      range6_examples.each do |example|
        it "complies with NIST SP250-81 sample on range 6, #{example[:t90]} Celsius" do
          expect(function6.wdev example[:t90]).to be_within(1e-8).of(example[:wdev])
        end
      end
    end
  end

  context 'temperature function' do
    t90_examples = 
      JSON.parse(File.read('spec/assets/models/its90_function/t90_examples.json'), symbolize_names: true)
    ipq_sprt = 
      JSON.parse(File.read('spec/assets/models/its90_function/ipq_sprt.json'), symbolize_names: true)
    let(:function) { create :its90_function, sub_range: 7, rtpw: ipq_sprt[:rtpw], a: ipq_sprt[:a], b:ipq_sprt[:b] }
    t90_examples.each do |example|
      it "complies with IPQ cert. 501.20/1241312 range 7, #{example[:t90]} Celsius" do
        expect(function.t90 example[:res]).to be_within(0.0001).of(example[:t90])
      end
    end
  end

  context 'resistance function' do
    it 'implements #r function placeholder' do
      expect(Its90Function.new.r 0).to be_nil
    end
  end

  context 'range function' do
    sub_ranges = 
      JSON.parse(File.read('spec/assets/models/its90_function/sub_ranges.json'), symbolize_names: true)
    sub_ranges.each do |example|
      it "returns #{example[:t_min]}..#{example[:t_max]} for sub_range #{example[:sub_range]}" do
        function = build :its90_function, sub_range: example[:sub_range]
        expect(function.range).to eq example[:t_min]..example[:t_max]
      end
    end
  end
end
