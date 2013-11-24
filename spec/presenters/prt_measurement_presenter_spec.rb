require 'spec_helper'

describe PrtMeasurementPresenter do
  include ActionView::TestCase::Behavior
  
  let(:measurement) do
    double(PrtMeasurement, temperature: 0, resistance: 100, 
                           r0: 100, 
                           a: 3.9083E-03, b: -5.775E-07, c: -4.183E-12, 
                           created_at: Time.new(2013) )
  end
  let(:presenter)   { PrtMeasurementPresenter.new measurement, view }

  it 'presents temperature with 3 decimals and unit' do
   expect(presenter.temperature).to eq '0.000 ºC' 
  end

  it 'presents resistance with 4 decimals and unit' do
   expect(presenter.resistance).to eq '100.0000 Ohm' 
  end

  it 'presents missing resistance as "-----"' do
    no_resistance_measurement = double(PrtMeasurement, resistance: nil)
    presenter = PrtMeasurementPresenter.new no_resistance_measurement, view
    expect(presenter.resistance).to eq '-----'
  end
end

