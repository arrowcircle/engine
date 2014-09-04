class Gtengine::Simple::Turbine
  attr_accessor :burner, :l_k, :average, :output, :options

  DEFAULTS = {
    eta: 0.9,
    eta_m: 0.985,
    g_ohl: 0.001,
    kpd: 0.9
  }

  def initialize(burner, l_k, options = {})
    @burner, @l_k = burner, l_k
    @options = DEFAULTS.merge(options)
    cycle
  end

  def input
    burner.output
  end

  def kpd
    options[:kpd]
  end

  def g_ohl
    options[:g_ohl]
  end

  def eta_m
    options[:eta_m]
  end

  def eta
    options[:eta]
  end

  def t_vh
    burner.output.t
  end

  def p_vh
    burner.output.p
  end

  def pi_t
    (1.0 / (1.0 - temp_pi_t)) ** ((k - 1.0) / k)
  end

  def cycle
    @average = Gtengine::Gas.new(t_vh, p_vh)
    5.times { update_average }
    @output = Gtengine::Gas.new(t_vyh, p_vyh)
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
    average.average_k
  end

  def cp
    average.average_cp
  end

  def info
    puts "== Turbine Cp_sr: #{cp}, K: #{k}, Pi_t: #{pi_t}, КДП: #{eta}"
    puts "==== Вход T: #{t_vh.to_i} K, P: #{p_vh.to_i} Па, ALFA: #{input.alfa}, Cp: #{input.cp}"
    puts "==== Выход T: #{output.t.to_i} K, P: #{output.p.to_i} Па, , Cp: #{output.cp}\n\n"
  end

  private

  def temp_pi_t
    (l_k / (1.0 + burner.q_ks)) / (t_vh * cp * eta * eta_m * (1.0 - g_ohl))
  end
end
