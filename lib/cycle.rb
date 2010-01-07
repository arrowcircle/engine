include Math
require 'compressor.rb'
require 'properties.rb'
require 'turbine.rb'
require 'nozzle.rb'
require 'cycle.rb'

class Optimum
  attr_accessor :cr, :pi_vl, :piks, :r, :m
  def initialize(cr,pi_vl, piks, r, m)
    @cr = cr
    @pi_vl = pi_vl
    @piks = piks
    @r = r
    @m = m
  end
  def show
    puts "########"
    puts "Cycle optimal values:"
    puts "Pi_k_sum: "+@piks.to_s
    puts "Pi_vl: "+@pi_vl.to_s
    puts "m: "+@m.to_s
    puts "R_ud: "+@r.to_s
    puts "C_r: "+@cr.to_s
    puts "########"
  end
end

class Cycle
  attr_accessor :tg, :pa, :m, :r_tyag, :mah, :ta, :opt, :c, :v, :tc, :tv, :n1, :n2
  def initialize(tg,pa,m, r_tyag,mah,ta)
    @tg = tg
    @pa = pa
    @m = m
    @r_tyag = r_tyag
    @mah = mah
    @ta = ta
    #@opt = self.find_optimum(2,5,20,40,1.1,2.5)
  end

  def calc(piks, pi_vl)
    #piks = суммарная степень повышения давления
    sigma_g = 0.965
    g_ohl = 0.01
    c_t_k = 200.0
    t0 = 288.3
    qn = 43000000
    sigma_vh = 0.985
    sigma_ll = 0.99
    sigma_ks = 0.99
    eta_k = 0.86
    eta_t = 0.9
    eta_l = 0.9
    eta_g = 0.985
    eta_vl = 0.86
    eta_m = 0.985
    eta_red = 0.995
    t_l_dop = 1200
    @k_vl = 1.4
    pi_v = (1 + ((@k_vl-1)/2)*@mah**2)
    pi_v = pi_v**(@k_vl/(@k_vl-1))
    p_vh = @pa*pi_v
    p_vh *= sigma_vh
    t_vh = @ta*(1 + ((@k_vl-1)/2)*@mah**2)
    v = Compressor.new(p_vh, t_vh, pi_vl, eta_k)
    c = Compressor.new(v.p_k, v.t_k, piks/pi_vl, eta_k)
    p_g = c.p_k*sigma_ks
    q_ks = (get_sr_cp(@tg,1)*@tg-get_sr_cp(c.t_k,10000000000)*c.t_k - (get_sr_cp(@tg,1)-get_sr_cp(c.t_k,10000000000))*t0)/(qn*eta_g-(get_sr_cp(@tg,1)*@tg - get_sr_cp(t0,1)*t0))
    alfa = get_alfa(c.t_k)
    teta = (@tg-t_l_dop)/(@tg-c.t_k)
    g_ohl = 5.9*teta/((1-1.42*teta))
    g_ohl = g_ohl/100
    g_ohl = 0 if g_ohl < 0
    tc = Turbine.new(p_g, @tg, eta_t, c, q_ks, alfa, 0, g_ohl, eta_m)
    tv = Turbine.new(tc.p_t, tc.t_t, eta_t, v, q_ks, alfa, @m, 0, eta_m)
    p_t = tv.p_t
    q_t = q_ks*(1-g_ohl)
    pi_s1 = p_t/@pa
    @c = c
    @v = v
    @tc = tc
    @tv = tv
    @n1 = Nozzle.new(pi_s1, tv.t_t, tv.k, q_t, @mah, @ta)
    rud1 = @n1.get_traction1
    @n2 = Nozzle.new(pi_vl, v.t_k, v.k, 0, @mah, @ta)
    rud2 = @n2.get_traction2
    rud = (rud1 + rud2)/(1+@m)
    cr = 3600*q_t/(rud*(@m+1))
    return cr,rud
  end
end