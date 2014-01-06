require 'spec_helper'

describe Iec60584FunctionPresenter do
  include ActionView::TestCase::Behavior
  
  let(:function) do
    double(Iec60584Function, name: 'FUNCTION01', type: 'K',
                             a3: 0, a2: 0, a1: 0, a0: 0)
  end
  let(:presenter) { Iec60584FunctionPresenter.new function, view }

  it 'delegates type presentation to Iec60584Function' do
   expect(presenter.type).to eq function.type
  end

  it 'presents a3, a2, a1, a0 as scientific notation, 5 decimals' do
    expect(presenter.a3).to eq '+0.00000E+00'
    expect(presenter.a2).to eq '+0.00000E+00'
    expect(presenter.a1).to eq '+0.00000E+00'
    expect(presenter.a0).to eq '+0.00000E+00'
  end
end

