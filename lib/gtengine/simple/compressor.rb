class Gtengine::Simple::Compressor
  attr_accessor :input, :output, :g, :pi_k, :kpd, :average

  def initialize input, pi_k, kpd
    @input = input
    @pi_k = pi_k.to_f
    @kpd = kpd.to_f
    @average = Gtengine::Gas.new input.t.to_f, input.p.to_f
    cycle
  end

  def t_vyh
    @input.t * (1.0 + ((pi_k ** ((k - 1.0) / k) - 1.0) / kpd))
  end

  def p_vyh
    @input.p * @pi_k
  end

  def l_k
    @average.cp * t_vyh * (@pi_k ** ((k - 1.0) / k) - 1.0) / @kpd
  end

  def k
    @average.average_k
  end

  def cp
    @average.average_cp
  end

  def alfa
    1.577 * 0.0000001 * t_vyh ** 2.383 + 1.774
  end

  def update_average
    @average.t = (t_vh + t_vyh) / 2.0
    @average.p = (p_vh + p_vyh) / 2.0
  end

  def t_vh
    @input.t
  end

  def p_vh
    @input.p
  end

  def cycle
    5.times do
      update_average
    end
    @output = Gtengine::Gas.new t_vyh, p_vyh
  end

  def info
    puts "== Compressor"
    puts "==== Pi_k: #{@pi_k}, КДП: #{@kpd}"
    puts "==== Вход T: #{@input.t.to_i} K, P: #{@input.p.to_i} Па"
    puts "====== Cp_sr: #{cp}, K: #{k}"
    puts "==== Выход T: #{@output.t.to_i} K, P: #{@output.p.to_i} Па, ALFA: #{alfa}"
    puts
  end

end