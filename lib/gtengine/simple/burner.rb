class Gtengine::Simple::Burner

  attr_accessor :input, :q_t, :output, :t_g

  T0 = 288.3
  QN = 43000000.0
  ETA_G = 0.985
  L0 = 14.7

  def initialize input, t_g
    @input, @t_g = input, t_g
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

  def p_vh
    @input.p
  end

  def q_ks
    (cp_vyh * t_g - cp_vh * t_vh - (cp_vyh - cp_vh) * T0) / (QN * ETA_G - (cp_vyh * t_g - cp_mult_t_0))
  end

  def cp_mult_t_0
    Gtengine::Gas.new(T0, 101325.0, 1.0).cp * T0
  end

  def alfa
    begin
      1.0 / (q_ks * L0)
    rescue
      999999999.0
    end
  end

  def cycle
    @output = Gtengine::Gas.new(t_g, p_vh, input.alfa)
    5.times { @output.alfa = alfa }
  end

  def info
    puts "== Burner q_ks: #{q_ks}, ALFA: #{alfa}"
    puts "==== Вход T: #{@input.t.to_i} K, P: #{@input.p.to_i} Па"
    puts "==== Выход T: #{@output.t.to_i} K, P: #{@output.p.to_i} Па\n\n"
  end
end