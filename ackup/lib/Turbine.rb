include Math
require 'properties.rb'
require 'compressor.rb'
class Turbine
  attr_accessor :eta, :p_g, :t_g, :eta, :l_t, :cp, :k, :pi_t, :p_t, :t_t, :g_ohl, :l_t

  def initialize(p_g, t_g, eta, comps, q_ks, alfa, m, g_ohl, eta_m = 0.985)
    #raise "invalid compressor input" if comps.class != Compressor
    @p_g = p_g
    @t_g = t_g
    @eta = eta
    @k = 1.33
    @cp = 1200.0
    @t_t = 100.0
    @compr_work = 0
    for c in comps do
        @compr_work += c.l_k
     end
    5.times do
      @pi_t = @compr_work/(1+q_ks)
      @pi_t /= @cp*t_g*@eta*eta_m*(1-g_ohl)
      @pi_t = 1/(1-@pi_t)
      @pi_t = @pi_t**(@k/(@k-1))


      #@pi_t = (c.k*287.2*c.t_vh)/(c.k-1)
      #@pi_t /= (@k*289*@t_g)/(@k-1)
      #@pi_t *= ((c.pi_k**((c.k-1)/c.k))-1)*(m+1)
      #@pi_t /= (1+q_ks)*(1-g_ohl)
      #@pi_t /= c.eta*@eta*eta_m
      #@pi_t = 1 - @pi_t
      #@pi_t = @pi_t**(-@k/(@k-1))
      tmp = @pi_t**((@k-1)/@k)
      @t_t = @t_g*(1-(1-1/tmp)*@eta)
      gaz = c.cp/@cp
      t_t_sr = (@t_g + @t_t)/2
      @cp = get_sr_cp(t_t_sr,alfa)
      @k = @cp/(@cp - 289)
    end
    @p_t = @p_g/@pi_t
    @l_t = @cp*@t_g*(1-@pi_t**((1-@k))/@k)*@eta*(1+q_ks)*(1-g_ohl)
  end
  def show
    puts "########"
    puts "Turbine:"
    puts "Pi_t: "+@pi_t.to_s
    puts "P_g: "+@p_g.to_s
    puts "T_g: "+@t_g.to_s
    puts "KPD: "+@eta.to_s
    puts "P_t: "+@p_t.to_s
    puts "T_t: "+@t_t.to_s
    puts "Cp: "+@cp.to_s
    puts "k: "+@k.to_s
    puts "L_t: "+@l_t.to_s
    puts "########"
  end
end