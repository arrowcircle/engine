require 'spec_helper'

describe Gtengine::Gas do
  let(:gas) { Gtengine::Gas.new }

  it "Считает плотность" do
    expect(gas.density).to eq 1.1751913709116215
  end

  it "Считает k" do
    expect(gas.k).to eq 1.4019467210274585
  end

  it "Считает k за процесс" do
    expect(gas.average_k).to eq 1.4034884084723653
  end

  context "LOW TEMPERATURE" do
    it "Считает теплоемкость" do
      expect(gas.cp).to eq 1002.4201381549933
    end

    it "Считает теплоемкость за процесс" do
      expect(gas.average_cp).to eq 999.6881202166772
    end
  end

  context "HIGH TEMPERATURE" do
    let(:gas) { Gtengine::Gas.new 900, 1013251 }

    it "Считает теплоемкость" do
      expect(gas.cp).to eq 1121.2960248302861
    end

    it "Считает теплоемкость за процесс" do
      expect(gas.average_cp).to eq 1037.119900706556
    end
  end
end