require 'spec_helper'

describe Gtengine::Simple::Compressor do
  let(:gas) { Gtengine::Gas.new }
  let(:compressor) { Gtengine::Simple::Compressor.new(gas, 10) }

  it "считает давление выхода" do
    expect(compressor.p_vyh).to eq 1013250.0
  end

  it "считает температуру выхода" do
    expect(compressor.t_vyh).to eq 627.5847203290919
  end

  it "считает работу компрессора" do
    expect(compressor.l_k).to eq 701724.7666737017
  end

  it "считает альфа" do
    expect(compressor.alfa).to eq 2.5062930805003583
  end
end