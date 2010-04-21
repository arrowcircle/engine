include Math
require 'properties.rb'
class Compressor
  attr_accessor :eta, :p_vh, :t_vh, :p_k, :t_k, :l_k, :cp, :k, :pi_k, :m
  def initialize(p_vh,t_vh, pi_k, eta, m)
    @p_vh = p_vh
    @t_vh = t_vh
    @pi_k = pi_k
    @eta = eta
    @k = 1.4
    @cp = 1006.0
    @m = m
    5.times do
      @t_k = t_vh*(1+(pi_k**((@k-1)/@k)-1)/eta)
      tk_sr = (@t_k + t_vh)/2
      @cp = get_real_cp(tk_sr,1000000)
      @k = @cp/(@cp - 287.2)
    end
    @l_k = @cp*t_vh*(((pi_k**((@k-1)/@k))-1)/eta)
    @l_k = (m+1)*@cp*t_vh*(((pi_k**((@k-1)/@k))-1)/eta) if m != 0
    @p_k = p_vh*pi_k
  end
  def show
    puts "########"
    puts "Compressor:"
    puts "Pi_k: "+@pi_k.to_s
    puts "P_vh: "+@p_vh.to_s
    puts "T_vh: "+@t_vh.to_s
    puts "KPD: "+@eta.to_s
    puts "P_k: "+@p_k.to_s
    puts "T_k: "+@t_k.to_s
    puts "L_k: "+@l_k.to_s
    puts "Cp: "+@cp.to_s
    puts "k: "+@k.to_s
    puts "########"
  end
end