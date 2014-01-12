# coding: utf-8
class Cycle::Burner

  attr_accessor :input, :q_t, :output, :t_g

  T0 = 288.3
  QN = 43000000.0
  ETA_G = 0.985
  L0 = 14.7

  def initialize input, t_g
    @input = input
    @t_g = t_g
    @output = Gas.new(t_g, @input.p, @input.alfa)
    cycle
  end

  def cp_vh
    @input.cp
  end

  def cp_vyh
    @output.cp
  end

  def t_vh
    @input.t
  end

  def q_ks
    (cp_vyh * t_g - cp_vh * t_vh - (cp_vyh - cp_vh) * T0) / (QN * ETA_G - (cp_vyh * t_g - cp_mult_t_0))
  end

  def cp_mult_t_0
    Gas.new(T0, 101325.0, 1.0).cp * T0
  end

  def alfa
    begin
      1.0 / (q_ks * L0)
    rescue
      999999999.0
    end
  end

  def cycle
    5.times do
      @output.alfa = alfa
    end
  end

  def info
    puts "== Burner"
    puts "==== q_ks: #{q_ks}, ALFA: #{alfa}"
    puts
  end
end