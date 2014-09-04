require 'spec_helper'

describe Gtengine::Simple::Turbine do
  let(:gas) { Gtengine::Gas.new }
  let(:compressor) { Gtengine::Simple::Compressor.new(gas, 10) }
  let(:burner) { Gtengine::Simple::Burner.new(compressor.output, 900) }
  let(:turbine) { Gtengine::Simple::Turbine.new(burner, compressor.l_k) }

  it "считает степень понижения давления" do
    expect(turbine.pi_t).to eq 1.6842480477100261
  end

  it "считает температуру выхода" do
    expect(turbine.t_vyh).to eq 790.5487885221904
  end

  it "считает давление выхода" do
    expect(turbine.p_vyh).to eq 601603.7847736602
  end

  it "считает работу турбины l_t" do
    expect(turbine.l_t).to eq 112962.28663065929
  end

end