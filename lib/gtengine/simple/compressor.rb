class Gtengine::Simple::Compressor
  include Gtengine::Defaults
  attr_accessor :input, :output, :g, :pi_k, :average, :options

  DEFAULTS = {
    kpd: 0.85
  }

  def initialize(input, pi_k, options = {})
    @input, @pi_k = input, pi_k.to_f
    @options = DEFAULTS.merge(options)
    cycle
  end

  def t_vyh
    input.t * (1.0 + ((pi_k ** ((k - 1.0) / k) - 1.0) / kpd))
  end

  def p_vyh
    input.p * pi_k
  end

  def l_k
    average.cp * t_vyh * (pi_k ** ((k - 1.0) / k) - 1.0) / kpd
  end

  def k
    average.average_k
  end

  def cp
    average.average_cp
  end

  def alfa
    1.577 * 0.0000001 * t_vyh ** 2.383 + 1.774
  end

  def t_vh
    input.t
  end

  def p_vh
    input.p
  end

  def update_average
    @average.t = (t_vh + t_vyh) / 2.0
    @average.p = (p_vh + p_vyh) / 2.0
  end

  def cycle
    @average = Gtengine::Gas.new(input.t.to_f, input.p.to_f)
    5.times { update_average }
    @output = Gtengine::Gas.new(t_vyh, p_vyh)
  end

  def info
    puts "== Compressor Pi_k: #{@pi_k}, КДП: #{kpd}, Cp_sr: #{cp}, K: #{k}"
    puts "==== Вход T: #{input.t.to_i} K, P: #{input.p.to_i} Па"
    puts "==== Выход T: #{output.t.to_i} K, P: #{output.p.to_i} Па, ALFA: #{alfa}\n\n"
  end
end
