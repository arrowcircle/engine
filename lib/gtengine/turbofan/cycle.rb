include Math
require 'compressor.rb'
require 'properties.rb'
require 'turbine.rb'
require 'nozzle.rb'
require 'cycle.rb'

class Optimum
  attr_accessor :cr, :piks, :r, :m, :pi_vl
  def initialize(cr, piks, r, m, pi_vl)
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
    #puts "Pi_vl: "+@pi_vl.to_s
    puts "m: "+@m.to_s
    puts "R_ud: "+@r.to_s
    puts "C_r: "+@cr.to_s
    puts "########"
  end
end

class Cycle
  attr_accessor :tg, :pa, :m, :r_tyag, :mah, :ta, :opt, :c, :v, :p, :tc, :tv, :n1, :n2, :pi_pp, :r2, :r1
  def initialize(tg,pa,m, r_tyag,mah,ta, pi_pp)
    @tg = tg
    @pa = pa
    @m = m
    @r_tyag = r_tyag
    @mah = mah
    @ta = ta
    @pi_pp = pi_pp
    #@opt = self.find_optimum(2,5,20,40,1.1,2.5)
  end

  def pre(piks)
    sigma_g = 0.965
    g_ohl = 0.01
    c_t_k = 200.0
    t0 = 288.3
    qn = 43000000
    sigma_vh = 0.985
    sigma_ll = 0.99
    sigma_ks = 0.99
    eta_k = 0.84
    @eta_t = 0.9
    eta_l = 0.9
    eta_g = 0.985
    eta_vl = 0.88
    eta_m = 0.985
    eta_red = 0.995
    t_l_dop = 1200
    @cp_g = 1200
    @k_g = 1.33
    pi_s1 = 1.83
    @cp_v = 1006
    @k_v = 1.4
    5.times do
      pi_v = (1 + ((@k_v-1)/2)*@mah**2)
      pi_v = pi_v**(@k_v/(@k_v-1))
      p_vh = @pa*pi_v
      p_vh *= sigma_vh
      t_vh = @ta*(1 + ((@k_v-1)/2)*@mah**2)
      @t_k = t_vh*(1+(piks**((@k_v-1)/@k_v)-1)/eta_k)
      tk_sr = (@t_k + t_vh)/2
      @cp_v = get_real_cp(tk_sr,1000000)
      @k_v = @cp_v/(@cp_v - 287.2)
    end
    alfa = get_alfa(@t_k)
    teta = (@tg-t_l_dop)/(@tg-@t_k)
    g_ohl = 5.9*teta/((1-1.42*teta))
    g_ohl = g_ohl/100
    g_ohl = 0 if g_ohl < 0
    q_ks = (get_sr_cp(@tg,1)*@tg-get_sr_cp(@t_k,10000000000)*@t_k - (get_sr_cp(@tg,1)-get_sr_cp(@t_k,10000000000))*t0)/(qn*eta_g-(get_sr_cp(@tg,1)*@tg - get_sr_cp(t0,1)*t0))
    @pi_t_sum = 1.0
    @pi_vl = 1.0
    @t_t = 1.0
    @p_t = 1.0
    @p_g = self.pa*sigma_g
    5.times do
      pi_t_sum = piks*sigma_g/pi_s1
      pi_vl = (1-g_ohl)*(1+q_ks)*@cp_g*@tg*(1-pi_t_sum**((1-@k_g)/@k_g)) - @cp_v*@ta*(piks**((@k_v-1)/@k_v)-1)/eta_k
      pi_vl /= (@m)*@cp_v*@ta/eta_vl
      pi_vl = (1 + pi_vl)**(@k_v/(@k_v-1))
      @pi_vl = pi_vl
      tmp = @pi_t_sum**((@k_g-1)/@k_g)
      @t_t = self.tg*(1-(1-1/tmp)*@eta_t)
      gaz = @cp_v/@cp_g
      t_t_sr = (self.tg + @t_t)/2
      @cp_g = get_sr_cp(t_t_sr,alfa)
      @k_g = @cp_g/(@cp_g - 289)
      @p_t = @p_g/@pi_t_sum
    end
    return @pi_vl
  end

  def calc(piks, pi_vl)
    #piks = суммарная степень повышения давления
    sigma_g = 0.965
    g_ohl = 0.25
    c_t_k = 200.0
    t0 = 288.3
    qn = 43000000
    l0 = 14.7
    sigma_vh = 0.9856
    sigma_ll = 0.99
    sigma_ks = 0.99
    eta_k = 0.86
    eta_t = 0.9
    eta_l = 0.9
    eta_g = 0.985
    eta_vl = 0.85
    eta_m = 0.985
    eta_red = 0.995
    t_l_dop = 1200
    @k_vl = 1.4
    @cp_g = 1200
    @k_g = 1.33
    pi_s1 = 1.83
    @cp_v = 1006
    @k_v = 1.4
    pi_v = (1 + ((@k_vl-1)/2)*@mah**2)
    pi_v = pi_v**(@k_vl/(@k_vl-1))
    p_vh = @pa*pi_v
    p_vh *= sigma_vh
    t_vh = @ta*(1 + ((@k_vl-1)/2)*@mah**2)
    #считаем общее Пи_турбин
    #pi_s1 = 1.2
    #pi_t_sum = piks*sigma_g/pi_s1
    #pi_vl = (1-g_ohl)*@cp_g*@tg*(1-pi_t_sum**((1-@k_g)/@k_g)) - @cp_v*@ta*(piks**((@k_v-1)/@k_v)-1)/eta_k
    #pi_vl /= (@m)*@cp_v*@ta/eta_vl
    #pi_vl = (1 + pi_vl)**(@k_v/(@k_v-1))
    #pi_vl = 1.4


    v = Compressor.new(p_vh, t_vh, pi_vl, 0.88, @m)
    
    p = Compressor.new(v.p_k, v.t_k, @pi_pp, 0.84, 0)
    @p = p
    c = Compressor.new(p.p_k, p.t_k, piks/(pi_vl*@pi_pp), 0.84, 0)

    vent = []
    compr = []
    vent << v
    vent << p
    compr << c
    p_g = c.p_k*sigma_ks
    q_ks = (get_sr_cp(@tg,1)*@tg-get_sr_cp(c.t_k,10000000000)*c.t_k )/(qn*eta_g + get_sr_cp(c.t_k,10000000000)*c.t_k-(get_sr_cp(@tg,1)*@tg  - get_sr_cp(t0,1)*t0))
    #q_ks = (get_sr_cp(@tg,1)*@tg-get_sr_cp(c.t_k,10000000000)*c.t_k )/(qn*eta_g -(get_sr_cp(@tg,1000000000)*@tg  + get_sr_cp(t0,1)*t0))
    #puts "q_ks = "+q_ks.to_s
    #alfa = get_alfa(c.t_k)
    alfa = 1/(q_ks*l0)
    teta = (@tg-t_l_dop)/(@tg-c.t_k)
    #g_ohl = 5.9*teta/((1-1.42*teta))
    #g_ohl = g_ohl/100
    #g_ohl = 0 if g_ohl < 0
    #g_ohl = 0.3 if g_ohl > 0.3
    g_ohl = 0.1
    tc = Turbine.new(p_g, @tg, eta_t, compr, q_ks, alfa, 0, g_ohl, eta_m)
    tv = Turbine.new(tc.p_t, tc.t_t, eta_t, vent, q_ks, alfa, @m, 0, eta_m)
    p_t = tv.p_t
    q_t = q_ks*(1-g_ohl)
    pi_s1 = p_t/@pa
    #puts pi_s1
    @c = c
    @v = v
    @tc = tc
    @tv = tv
    @n1 = Nozzle.new(pi_s1, tv.t_t, tv.k, q_t, @mah, @ta)
    rud1 = @n1.get_traction1
    @r1 = rud1
    
   # puts rud1
    @n2 = Nozzle.new(pi_vl*sigma_ll, v.t_k, v.k, 0, @mah, @ta)
    rud2 = @n2.get_traction1
    #puts rud2
    @r2 = rud2
    rud = (rud1 + @m*rud2)/(1.0+@m)
    cr = 3600.0*q_t/((1.0+@m)*rud)
    cr = 1 if pi_s1 > 3
    cr = 1 if pi_s1 < 1.001
    rud = 1 if cr == 1
    return cr,rud
  end
end


#cycle = Cycle.new(1800, 101500, 5.8, 0, 0, 288)
#cr,r = cycle.calc(28, 1.6)
#cr,r = cycle.calc(opt.piks, opt.pi_vl)
#cr,r = cycle.calc(29)
#cycle.v.show
#cycle.p.show
#cycle.c.show
#cycle.tc.show
#cycle.tv.show