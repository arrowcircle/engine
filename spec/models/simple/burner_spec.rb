require 'spec_helper'

describe Gtengine::Simple::Burner do
  let(:gas) { Gtengine::Gas.new }
  let(:compressor) { Gtengine::Simple::Compressor.new gas, 10, 0.87 }
  let(:burner) { Gtengine::Simple::Burner.new compressor.output, 1400 }

  it "считает расход топлива" do
    expect(burner.q_ks).to eq 0.026948712923834613
  end

  it "считает альфа" do
    expect(burner.alfa).to eq 2.524321331286569
  end
end