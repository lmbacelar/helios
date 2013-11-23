require 'spec_helper'
require 'json'

fixed_point_examples = 
  JSON.parse( File.read('spec/assets/models/its90_prt/fp_examples.json'), symbolize_names: true)

describe Its90Prt do
  context 'includes module' do
    it 'RetryMethods' do
      expect(Its90Prt.included_modules).to include RetryMethods
    end
  end

  context 'defaults' do
    let(:prt) { create :its90_prt, sub_range: 4 }
    it 'Rtpw to 25 Ohm' do
      expect(prt.rtpw).to be_within(1e-9).of(25)
    end

    it 'all other coefficients to 0.0' do
      expect(prt.a   ).to eq 0
      expect(prt.b   ).to eq 0
      expect(prt.c   ).to eq 0
      expect(prt.d   ).to eq 0
      expect(prt.w660).to eq 0
      expect(prt.c1  ).to eq 0
      expect(prt.c2  ).to eq 0
      expect(prt.c3  ).to eq 0
      expect(prt.c4  ).to eq 0
      expect(prt.c5  ).to eq 0
    end
  end

  context 'validations' do
    let(:prt) { create :its90_prt, sub_range: 4 }
    it 'requires name to be present' do
      expect(prt).to validate_presence_of :name
    end

    it 'requires name to be unique' do
      expect(prt).to validate_uniqueness_of :name
    end

    it 'requires sub_range to be present' do
      expect(prt).to validate_presence_of :sub_range
    end

    it 'requires sub_range to included in SUB_RANGES' do
      expect(prt).to ensure_inclusion_of(:sub_range).in_range(Its90Prt::SUB_RANGES)
    end
  end

  context 'reference funtions' do
    context 'wr computation' do
      fixed_point_examples.each do |example|
        it "complies on #{example[:fixed_point]} fixed point" do
          expect(Its90Prt.wr example[:t90]).to be_within(1e-8).of(example[:wr])
        end 
      end 

      it 'returns nil when out of range' do
        expect(Its90Prt.wr(-259.50)).to be_nil
        expect(Its90Prt.wr( 961.90)).to be_nil
      end 
    end 

    context 't90r computation' do
      fixed_point_examples.each do |example|
        it "complies on #{example[:fixed_point]} fixed point" do
          expect(Its90Prt.t90r example[:wr]).to be_within(0.00013).of(example[:t90])
        end
      end

      it 'returns nil when out of range' do
        expect(Its90Prt.t90r 0.001).to be_nil
        expect(Its90Prt.t90r 4.290).to be_nil
      end
    end
  end

  context 'deviation functions' do
    context 'wdev computation' do
      range4_examples = 
        JSON.parse(File.read('spec/assets/models/its90_prt/r4_examples.json'), symbolize_names: true)
      range4_sprt = 
        JSON.parse(File.read('spec/assets/models/its90_prt/r4_sprt.json'), symbolize_names: true)
      let(:prt4) { create :its90_prt, sub_range: 4, a: range4_sprt[:a], b:range4_sprt[:b] }
      range4_examples.each do |example|
        it "complies with NIST SP250-81 sample on range 4, #{example[:t90]} Celsius" do
          expect(prt4.wdev example[:t90]).to be_within(1e-8).of(example[:wdev])
        end
      end
      
      range6_examples =
        JSON.parse(File.read('spec/assets/models/its90_prt/r6_examples.json'), symbolize_names: true)
      range6_sprt = 
        JSON.parse(File.read('spec/assets/models/its90_prt/r6_sprt.json'), symbolize_names: true)
      let(:prt6) { create :its90_prt, sub_range: 6, a: range6_sprt[:a], b:range6_sprt[:b], c:range6_sprt[:c] }
      range6_examples.each do |example|
        it "complies with NIST SP250-81 sample on range 6, #{example[:t90]} Celsius" do
          expect(prt6.wdev example[:t90]).to be_within(1e-8).of(example[:wdev])
        end
      end
    end
  end

  context 'temperature function' do
    t90_examples = 
      JSON.parse(File.read('spec/assets/models/its90_prt/t90_examples.json'), symbolize_names: true)
    ipq_sprt = 
      JSON.parse(File.read('spec/assets/models/its90_prt/ipq_sprt.json'), symbolize_names: true)
    let(:prt) { create :its90_prt, sub_range: 7, rtpw: ipq_sprt[:rtpw], a: ipq_sprt[:a], b:ipq_sprt[:b] }
    t90_examples.each do |example|
      it "complies with IPQ cert. 501.20/1241312 range 7, #{example[:t90]} Celsius" do
        expect(prt.t90 example[:res]).to be_within(0.0001).of(example[:t90])
      end
    end
  end

  context 'range function' do
    sub_ranges = 
      JSON.parse(File.read('spec/assets/models/its90_prt/sub_ranges.json'), symbolize_names: true)
    sub_ranges.each do |example|
      it "returns #{example[:t_min]}..#{example[:t_max]} for sub_range #{example[:sub_range]}" do
        prt = build :its90_prt, sub_range: example[:sub_range]
        expect(prt.range).to eq example[:t_min]..example[:t_max]
      end
    end
  end
end
