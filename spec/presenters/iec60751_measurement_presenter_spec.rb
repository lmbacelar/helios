require 'spec_helper'

describe Iec60751MeasurementPresenter do
  include ActionView::TestCase::Behavior
  
  let(:measurement) do
    double('Iec60751Measurement', temperature: 0, resistance: 100, 
                                  r0: 100, 
                                  a: 3.9083E-03, b: -5.775E-07, c: -4.183E-12, 
                                  created_at: Time.new(2013) )
  end
  let(:presenter)   { Iec60751MeasurementPresenter.new measurement, view }

  it 'presents temperature with 3 decimals and unit' do
   expect(presenter.temperature).to eq '0.000 ºC' 
  end

  it 'presents resistance and r0 with 4 decimals and unit' do
    expect(presenter.resistance).to eq '100.0000 Ohm'
    expect(presenter.r0).to         eq '100.0000 Ohm'
  end

  it 'presents A, B, C as scientific notation, 5 decimals' do
    expect(presenter.a).to eq '+3.90830E-03'
    expect(presenter.b).to eq '-5.77500E-07'
    expect(presenter.c).to eq '-4.18300E-12'
  end

  it 'presents date as ISO 8601' do
    expect(presenter.date).to eq '2013-01-01'
  end

  it 'presents time as hh:mm:ss' do
    expect(presenter.time).to eq '00:00:00'
  end
end

