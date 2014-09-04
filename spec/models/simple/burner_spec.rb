require 'spec_helper'

describe Gtengine::Simple::Burner do
  let(:gas) { Gtengine::Gas.new }
  let(:compressor) { Gtengine::Simple::Compressor.new(gas, 10) }
  let(:burner) { Gtengine::Simple::Burner.new(compressor.output, 1400) }

  it "считает расход топлива" do
    expect(burner.q_ks).to eq 0.0255346596182821
  end

  it "считает альфа" do
    expect(burner.alfa).to eq 2.664112696283923
  end
end