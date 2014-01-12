require 'spec_helper'

describe Gas do
  let(:gas) { Gas.new }

  it "Считает плотность" do
    expect(gas.density).to eq 1.259133611691023
  end

  it "Считает k" do
    expect(gas.k).to eq 1.4029968590096924
  end

  it "Считает k за процесс" do
    expect(gas.average_k).to eq 1.404058445015607
  end

  context "LOW TEMPERATURE" do
    it "Считает теплоемкость" do
      expect(gas.cp).to eq 1000.556923124028
    end

    it "Считает теплоемкость за процесс" do
      expect(gas.average_cp).to eq 998.6832401978357
    end
  end

  context "HIGH TEMPERATURE" do
    let(:gas) { Gas.new 900, 1013251 }

    it "Считает теплоемкость" do
      expect(gas.cp).to eq 1121.2960248302861
    end

    it "Считает теплоемкость за процесс" do
      expect(gas.average_cp).to eq 1037.119900706556
    end
  end
end