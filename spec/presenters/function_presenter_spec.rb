require 'spec_helper'

describe FunctionPresenter do
  include ActionView::TestCase::Behavior
  
  let(:function) do
    double(TransferFunction, name: 'FUNCTION01')
  end
  let(:presenter) { FunctionPresenter.new function, view }

  it 'delegates name presentation to TransferFunction' do
   expect(presenter.name).to eq function.name
  end

  it 'yields #show_link for function' do
    pending
  end

  it 'yields #destroy_link for function' do
    pending
  end
end

