require 'spec_helper'

describe Iec60751Prt do
  context 'validations' do
    it 'requires name to be present' do
      expect(subject).to validate_presence_of :name
    end

    it 'requires name to be unique' do
      expect(subject).to validate_uniqueness_of :name
    end
  end
end
