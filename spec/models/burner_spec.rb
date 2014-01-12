require 'spec_helper'

describe Cycle::Burner do
  let(:gas) { Gas.new }
  let(:compressor) { Cycle::Compressor.new gas, 10, 0.87 }
  let(:burner) { Cycle::Burner.new compressor.output, 1400 }

  it "считает расход топлива" do
    expect(burner.q_ks).to eq 0.026948712923834613
  end

  it "считает альфа" do
    expect(burner.alfa).to eq 2.524321331286569
  end
end