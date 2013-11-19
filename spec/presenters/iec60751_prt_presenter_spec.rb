require 'spec_helper'

describe Iec60751PrtPresenter do
  include ActionView::TestCase::Behavior
  
  let(:prt) do
    double('Iec60751Prt', name: 'PRT01', description: 'Some description', 
                          r0: 100, 
                          a: 3.9083E-03, b: -5.775E-07, c: -4.183E-12)
  end
  let(:presenter) { Iec60751PrtPresenter.new prt, view }

  it 'delegates name presentation to Iec60751Prt' do
   expect(presenter.name).to eq prt.name
  end

  it 'delegates description presentation to Iec60751Prt' do
   expect(presenter.description).to eq prt.description
  end

  it 'presents r0 with 4 decimals and unit' do
    expect(presenter.r0).to eq '100.0000 Ohm'
  end

  it 'presents A, B, C as scientific notation, 5 decimals' do
    expect(presenter.a).to eq '+3.90830E-03'
    expect(presenter.b).to eq '-5.77500E-07'
    expect(presenter.c).to eq '-4.18300E-12'
  end
end

