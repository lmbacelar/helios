require 'spec_helper'

describe MeasurementPresenter do
  include ActionView::TestCase::Behavior
  
  let(:measurement) do
    double(Measurement, temperature: 0, resistance: 100, 
                        r0: 100, 
                        a: 3.9083E-03, b: -5.775E-07, c: -4.183E-12, 
                        created_at: Time.new(2013) )
  end
  let(:presenter) { MeasurementPresenter.new measurement, view }

  it 'presents date as ISO 8601' do
    expect(presenter.date).to eq '2013-01-01'
  end

  it 'presents time as hh:mm:ss' do
    expect(presenter.time).to eq '00:00:00'
  end
end

