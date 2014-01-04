require_relative '../../../app/models/concerns/mti.rb'
require 'active_support/core_ext'
require 'active_support/inflector'

describe Mti do
  context 'sets up associations' do
    it "belongs_to all the parent's children" do
      expect(Owner).to receive(:belongs_to).with(:daughter)
      expect(Owner).to receive(:belongs_to).with(:sun)
      Owner.belongs_to_mti :parent
    end
  end

  context 'parent accessors' do
    before(:each) do
      allow(Owner).to receive(:belongs_to)
      Owner.belongs_to_mti :parent
    end
    let(:owner) { Owner.new }

    context 'reader' do
      it 'delegates to the right child' do
        allow(owner).to receive(:sun)
        allow(owner).to receive(:daughter).and_return(Daughter.new)
        expect(owner).to receive(:daughter)
        owner.parent
      end
    end

    context 'writer' do
      it 'delegates to the right child' do
        expect(owner).to receive(:sun=)
        owner.parent = Sun.new
      end
    end
  end
end

class Parent; end
class Sun < Parent; end
class Daughter < Parent; end

class Owner; extend Mti; end
