require 'spec_helper'

describe Gtengine::Simple::Compressor do
  let(:gas) { Gtengine::Gas.new }
  let(:compressor) { Gtengine::Simple::Compressor.new gas, 10, 0.87 }

  it "считает давление выхода" do
    expect(compressor.p_vyh).to eq 1013250.0
  end

  it "считает температуру выхода" do
    expect(compressor.t_vyh).to eq 579.410983909093
  end

  it "считает работу компрессора" do
    expect(compressor.l_k).to eq 631083.3734847266
  end

  it "считает альфа" do
    expect(compressor.alfa).to eq 2.37938137624045
  end
end