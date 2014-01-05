require 'spec_helper'

describe Iec60584FunctionPresenter do
  include ActionView::TestCase::Behavior
  
  let(:function) do
    double(Iec60584Function, name: 'FUNCTION01',
                             a3: 1.1E-09, a2: -2.2E-04, a1: 3.3E-01, a0: -4.4E+00)
  end
  let(:presenter) { Iec60584FunctionPresenter.new function, view }
  it 'presents a3, a2, a1, a0 as scientific notation, 5 decimals' do
    expect(presenter.a3).to eq '+1.10000E-09'
    expect(presenter.a2).to eq '-2.20000E-04'
    expect(presenter.a1).to eq '+3.30000E-01'
    expect(presenter.a0).to eq '-4.40000E+00'
  end
end

