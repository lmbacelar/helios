require 'spec_helper'

describe TemperatureMeasurement do
  it 'defines :temperature as alias for :value' do
    m = build :temperature_measurement, temperature: 0
    expect(m.temperature).to eq 0
  end

  it 'sets :quantity to :temperature when saving' do
    m = create :temperature_measurement
    expect(m.quantity).to eq :temperature
  end
end
