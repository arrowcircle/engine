# coding: utf-8
require_relative '../gas'

class Cycle::Turbine

  attr_accessor :burner, :l_k, :kpd, :average, :output

  ETA = 0.9
  ETA_M = 0.985
  G_OHL = 0.001

  def initialize burner, l_k, kpd = 0.9
    @burner = burner
    @l_k = l_k
    @kpd = kpd.to_f
    @average = Gas.new t_vh, p_vh
    cycle
  end

  def input
    @burner.output
  end

  def t_vh
    burner.output.t
  end

  def p_vh
    burner.output.p
  end

  def pi_t
    pit = l_k / (1.0 + burner.q_ks)
    pit /= (t_vh * cp * ETA * ETA_M * (1.0 - G_OHL))
    pit = (1.0 / (1.0 - pit)) ** ((k - 1.0) / k)
    pit
  end

  def cycle
    5.times do
      update_average
    end
    @output = Gas.new t_vyh, p_vyh
  end

  def update_average
    @average.t = (t_vh + t_vyh) / 2.0
    @average.p = (p_vh + p_vyh) / 2.0
  end

  def t_vyh
    t_vh * (1.0 - ((1.0 - (pi_t ** ((1.0 - k) / k))) * kpd))
  end

  def p_vyh
    p_vh / pi_t
  end

  def l_t
    cp * t_vh * ((1.0 - (pi_t ** ((1.0 - k) / k))) * kpd)
  end

  def k
    @average.average_k
  end

  def cp
    @average.average_cp
  end

  def info
    puts "== Turbine"
    puts "==== Pi_t: #{pi_t}, КДП: #{ETA}"
    puts "==== Вход T: #{t_vh.to_i} K, P: #{p_vh.to_i} Па, ALFA: #{input.alfa}, Cp: #{input.cp}"
    puts "====== Cp_sr: #{cp}, K: #{k}"
    puts "==== Выход T: #{@output.t.to_i} K, P: #{@output.p.to_i} Па, , Cp: #{@output.cp}"
    puts
  end

end