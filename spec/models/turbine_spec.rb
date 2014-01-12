require 'spec_helper'

describe Cycle::Turbine do
  let(:gas) { Gas.new }
  let(:compressor) { Cycle::Compressor.new gas, 10, 0.87 }
  let(:burner) { Cycle::Burner.new compressor.output, 900 }
  let(:turbine) { Cycle::Turbine.new burner, compressor.l_k }

  it "считает степень понижения давления" do
    expect(turbine.pi_t).to eq 1.4858595860294537
  end

  it "считает температуру выхода" do
    expect(turbine.t_vyh).to eq 815.5179703599931
  end

  it "считает давление выхода" do
    expect(turbine.p_vyh).to eq 681928.5008670494
  end

  it "считает работу турбины l_t" do
    expect(turbine.l_t).to eq 87289.27555567237
  end
  
end