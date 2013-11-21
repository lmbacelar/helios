require 'spec_helper'

describe Its90PrtPresenter do
  include ActionView::TestCase::Behavior
  
  let(:prt) do
    double(Its90Prt, name: 'PRT01', 
                     sub_range: 1,
                     rtpw: 25, 
                     a: 0, b: 0, c: 0, d: 0, w660: 0,
                     c1: 0, c2: 0, c3: 0, c4: 0, c5: 0)
  end
  let(:presenter) { Its90PrtPresenter.new prt, view }

  it 'delegates name presentation to Its90Prt' do
   expect(presenter.name).to eq prt.name
  end

  it 'delegates sub_range presentation to Its90Prt' do
   expect(presenter.sub_range).to eq prt.sub_range
  end

  it 'presents rtpw with 6 decimals and unit' do
    expect(presenter.rtpw).to eq '25.000000 Ohm'
  end

  it 'presents a, b, c, d, w660, c1, c2, c3, c4, c5 as scientific notation, 6 decimals' do
    expect(presenter.a   ).to eq '+0.000000E+00'
    expect(presenter.b   ).to eq '+0.000000E+00'
    expect(presenter.c   ).to eq '+0.000000E+00'
    expect(presenter.d   ).to eq '+0.000000E+00'
    expect(presenter.w660).to eq '+0.000000E+00'
    expect(presenter.c1  ).to eq '+0.000000E+00'
    expect(presenter.c2  ).to eq '+0.000000E+00'
    expect(presenter.c3  ).to eq '+0.000000E+00'
    expect(presenter.c4  ).to eq '+0.000000E+00'
    expect(presenter.c5  ).to eq '+0.000000E+00'
  end
end

