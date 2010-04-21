include Math
require 'properties.rb'


class Compressor

  attr_accessor :eta, :p_vh, :t_vh, :p_k, :t_k, :l_k, :cp, :k, :pi_k, :m, :stages, :calc
  def initialize(p_vh,t_vh, pi_k, eta, m)
    @stages = []
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
    #@l_k = @cp*t_vh*(((pi_k**((@k-1)/@k))-1)/eta)
    @l_k = (m+1)*@cp*t_vh*(((pi_k**((@k-1)/@k))-1)/eta)
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

class Calc
  attr_accessor :z
  def initialize(comp,g)
    #Коэффициент теоретического напора средней ступени
    h_tk_sr_otn = 0.4
    #средняя окружная скорость на периферии компрессора
    u_pk_sr = 350.0
    #теоретический напор средней ступени
    h_t_sr = h_tk_sr_otn*(u_pk_sr**2)
    #Число ступеней
    @z = comp.l_k/h_t_sr
    puts "Numer of Stages = "+@z.to_s+", Z = "+(@z.to_i+1).to_s
    #Удельная работа ступени
    l_ud_st = comp.l_k/@z
    puts "L_ud_stupeni = "+l_ud_st.to_s
    #Коэффициент расхода на входе
    ca_otn_1 = 0.65
    #Относительный диаметр втулки на входе
    d_otn_1 = 0.4
    #Осевая скорость на входе в компрессор
    ca_1 = ca_otn_1*u_pk_sr
    #Осевая скорость на выходе из компрессор
    ca_vyh = ca_1 - @z*10
    puts "Ca_1 = "+ca_1.to_s+" || Ca_vyh = "+ca_vyh.to_s
    #Критическая скорость на входе в компрессор
    a_kr_1 = get_a(comp.k,287.2,comp.t_vh)
   
    #Критическая скорость на выходе из компрессора
    a_kr_vyh = get_a(comp.k,287.2,comp.t_k)
    puts "a_kr_vh = "+okr(a_kr_1,3).to_s+" || a_kr_vyh = "+okr(a_kr_vyh,3).to_s
    #Приведённая осевая скорость на входе и выходе из компрессора
    lam_kr_1 = ca_1/a_kr_1
    lam_kr_vyh = ca_vyh/a_kr_vyh
    puts "lambda_vh = "+okr(lam_kr_1,3).to_s+" || lambda_vyh = "+okr(lam_kr_vyh,3).to_s
    #потери во входныом и выходном патрубке
    dzeta_vh = 0.03
    dzeta_vyh = 0.3
    sig_vh = dzeta_vh*comp.k*get_eps(lam_kr_1,comp.k)*(lam_kr_1**2)
    sig_vh = sig_vh/(comp.k+1)
    sig_vh = 1+sig_vh
    sig_vh = 1/sig_vh
    sig_vyh = dzeta_vyh*comp.k*get_eps(lam_kr_vyh,comp.k)*(lam_kr_vyh**2)
    sig_vyh = sig_vyh/(comp.k+1)
    sig_vyh = 1+sig_vyh
    sig_vyh = 1/sig_vyh
    puts "SIGMA_vh = "+okr(sig_vh,3).to_s+" || SIGMA_vyh = "+okr(sig_vyh,3).to_s
    #Параметры воздуха на входе и выходе из компрессора
    p_1 = comp.p_vh*sig_vh
    p_vyh = p_1*comp.pi_k
    ro_1 = p_1*get_eps(lam_kr_1,comp.k)/(287.2*comp.t_vh)
    puts "ro_vh = "+okr(ro_1,3).to_s
    ro_vyh = p_vyh*get_eps(lam_kr_vyh,comp.k)/(287.2*comp.t_k)
    puts "ro_vyh = "+okr(ro_vyh,3).to_s
    #частота вращения
    n = (1-d_otn_1**2)*ca_otn_1*(u_pk_sr**3)*900.0*ro_1
    n = n/(g*3.1416)
    n = sqrt(n)
    puts "n = "+n.to_s
    #Кольцевая площадь на входе и выходе из компрессора
    f1 = g*sqrt(287*comp.t_vh)/(1.87*get_q(lam_kr_1,comp.k)*p_1)
    f_vyh = g*sqrt(287*comp.t_k)/(1.87*get_q(lam_kr_vyh,comp.k)*p_vyh)
    puts "F1 = "+okr(f1,3).to_s+" || F2 = "+okr(f_vyh,3).to_s
    #Диаметры первой и последней ступени компрессора
    d_p_1 = 60.0*u_pk_sr/(3.14*n)
    d_vt_1 = d_p_1*d_otn_1
    d_sr_1 = 0.5*(d_p_1+d_vt_1)
    #d_p_vyh = d_p_1
    d_vt_vyh = d_vt_1
    #d_vt_vyh = d_p_vyh**2 - (4*f_vyh)/3.14
    #d_vt_vyh = sqrt(d_vt_vyh)
    d_p_vyh = d_vt_vyh**2 + (4*f_vyh)/3.14
    d_p_vyh = sqrt(d_p_vyh)
    d_sr_vyh = 0.5*(d_p_vyh+d_vt_vyh)
    d_otn_vyh = d_vt_vyh/d_p_vyh
    puts "D_per_1 = "+okr((1000*d_p_1),3).to_s+" || D_vt_1 = "+okr((1000*d_vt_1),3).to_s+" || D_sr_1 = "+okr((1000*d_sr_1),3).to_s
    puts "D_per_vyh = "+okr((1000*d_p_vyh),3).to_s+" || D_vt_vyh = "+okr((1000*d_vt_vyh),3).to_s+" || D_sr_1 = "+okr((1000*d_sr_vyh),3).to_s
    puts "D_otn_vyh = "+okr(d_otn_vyh,3).to_s
    #высоты рабочих лопаток первой и последней ступени
    h_rl_1 = 0.5*(d_p_1-d_vt_1)
    h_rl_vyh = 0.5*(d_p_vyh-d_vt_vyh)
    puts "h_rl_1 = "+okr((1000*h_rl_1),3).to_s+" || h_rl_vyh = "+okr((1000*h_rl_vyh),3).to_s
    #приведённый расход и лобовая производительность
    g0 = 101325*g/p_1
    g0 = g0*sqrt(comp.t_vh/288.15)
    r_l = g0*4/(3.14*d_p_1**2)
    puts "G0 = "+okr(g0,3).to_s
    puts "P_l = "+okr(r_l,3).to_s
    stages = []
    k_h = [0.995,0.99,0.985,0.98,0.975,0.97, 0.965, 0.96, 0.955, 0.95, 0.945, 0.94,0.935, 0.93, 0,925,0.92]
    kpd = [0.865,0.875,0.885,0.89,0.89,0.88, 0.875, 0.87, 0.865, 0.86, 0.855, 0.85, 0.845, 0.84, 0.835, 0.83]
    #Stage.initialize(h_t, h_t_otn, k_h, eta_ad, k, t_vh, p_vh, d_otn, u_p, r, c_a,lam_vh, f_1,d_vt_vh, print=false)
    puts "##########Stage 1############"
    stages << Stage.new(u_pk_sr,0.37,k_h[0],kpd[0],comp.k,comp.t_vh,p_1,d_otn_1, u_pk_sr, 0.65,ca_1,lam_kr_1,g,d_vt_1, true)
    for i in 1..@z+1 do
      puts "##########Stage "+(i+1).to_s+"############"
      stages << Stage.new(u_pk_sr,0.37,k_h[i],kpd[i],comp.k,stages[-1].t_vyh,stages[-1].p_vyh,d_otn_1, u_pk_sr, 0.65,ca_1,stages[-1].lam_3,g,d_vt_1, true)

    end
    pi_k = stages[-1].p_vyh/stages[0].p_vh
    puts "pi_k = "+okr((stages[-1].p_vyh/stages[0].p_vh),4).to_s
    kpd_la = (pi_k**((comp.k-1)/comp.k)-1)*stages[0].t_vh
    kpd_la = kpd_la/(stages[-1].t_vyh-stages[0].t_vh)
    puts "kpd_la = "+okr(kpd_la,4).to_s
  end

end


class Stage
  attr_accessor :h_t, :k_h, :eta_ad, :l_z, :delta_t, :k, :pi, :t_vh, :t_vyh, :p_vh, :p_vyh, :r, :u_p, :f3, :lam_3, :r3
  def initialize(u_k, h_t_otn, k_h, eta_ad, k, t_vh, p_vh, d_otn, u_p, r, c_a,lam_vh, g,d_vt_vh, print=false)

    @h_t = h_t_otn*(u_k**2)
    @k_h = k_h
    @eta_ad = eta_ad
    @k = k
    @u_p = u_p
    @t_vh = t_vh
    @p_vh = p_vh
    @l_z = @k_h*@h_t
    @h_ad = @l_z*@eta_ad
    @delta_t = (@l_z*(k-1))/(@k*287.0)
    @t_vyh = @t_vh + @delta_t
    @pi = (@h_ad*(k-1))
    @pi = @pi/(k*287.0*@t_vh)
    @pi = @pi + 1
    @pi = @pi**(k/(k-1.0))

    @p_vyh = @p_vh*@pi
    a_kr_1 = 2*k*287.0*@t_vh/(k+1)
    a_kr_1 = sqrt(a_kr_1)
    a_kr_3 = 2*k*287.0*@t_vyh/(k+1)
    a_kr_3 = sqrt(a_kr_3)
    r_sr_otn_1 = sqrt((1+d_otn**2)/2)
    @r = r
    c_u_otn_1 = r_sr_otn_1*(1-@r)-h_t_otn/2*r_sr_otn_1
    c_a_otn_1 = c_a/@u_p

    alfa_1 = atan(c_a_otn_1/c_u_otn_1)

    ##
    lam_1 = c_a/(sin(alfa_1)*a_kr_1)
    f_1 = g*sqrt(287.00*@t_vh)/(get_m(k)*sin(alfa_1)*@p_vh*get_q(lam_1,k))
    ##


    c_a_3 = c_a 
    #c_a_3 = c_a - 10.0
    c_a_3_otn = c_a_3/u_p
    c_1 = c_a/sin(alfa_1)
    #Первое приближение

    lam_3 = c_a_3/(sin(alfa_1)*a_kr_1)

    f_3 = f_1*get_q(lam_vh,k)*p_vh*sqrt(@t_vyh)/(get_q(lam_3,k)*@p_vyh*sqrt(@t_vh))

    d_vt_3 = d_vt_vh
    d_per_3 = sqrt(d_vt_3**2 + 4*f_3/3.14)
    d_otn_3 = d_vt_3/d_per_3

    r_sr_otn_3 = sqrt((1+d_otn_3**2)/2)
    #c_u_3_otn = (r_sr_otn_3*(1-r)-h_t_otn/(2*r_sr_otn_3)).abs
    c_u_3_otn = (r_sr_otn_3*(1-r)-h_t_otn/(2*r_sr_otn_3))
    alfa_3 = (atan(c_a_3_otn/c_u_3_otn))

    #Уточняем

    lam_3 = c_a_3/(sin(alfa_3)*a_kr_3)

    f_3 = f_3*get_q(lam_vh,k)/get_q(lam_3,k)

    d_per_3 = sqrt(d_vt_3**2 + 4*f_3/3.14)
   
    d_otn_3 = d_vt_3/d_per_3

    r_sr_otn_3 = sqrt((1+d_otn_3**2)/2)
    c_u_3_otn = r_sr_otn_3*(1-r)-h_t_otn/(2*r_sr_otn_3)

    alfa_3 = atan(c_a_3_otn/c_u_3_otn)

    lam_3 = c_a_3/(sin(alfa_3)*a_kr_3)

    c_vyh_na = c_a_3/sin(alfa_3)
    r_sr_otn_2 = 0.5*(r_sr_otn_3 + r_sr_otn_1)
    c_u_2_otn = (h_t_otn +c_u_otn_1*r_sr_otn_1)/r_sr_otn_2
    c_a_2 = c_a -5
    c_a_2_otn = c_a_2/u_p
    beta1 = atan(c_a_otn_1/(r_sr_otn_1-c_u_otn_1))
    beta2 = atan(c_a_2_otn/(r_sr_otn_2-c_u_2_otn))
    beta3 = atan(c_a_3_otn/(r_sr_otn_3-c_u_3_otn))

    w1 = c_a/sin(beta1)
    w2 = c_a_2/sin(beta2)
    w3 = c_a_3/sin(beta3)

    alfa2 = atan(c_a_2_otn/c_u_2_otn)

    eps_rk = beta2-beta1
    eps_na = alfa_3-alfa2

    c2 = c_a_2/sin(alfa2)
    t1 = @t_vh*get_tau(lam_vh,k)

    lam_2 = c2/a_kr_3

    t2 = (@t_vyh+@t_vh)*get_tau(lam_2,k)/2

    t3 = @t_vyh*get_tau(lam_3,k)

    a_1 = 2*k*287.0*t1/(k+1)
    a_1 = sqrt(a_1)
    a_2 = 2*k*287.0*t2/(k+1)
    a_2 = sqrt(a_2)
    a_3 = 2*k*287.0*t3/(k+1)
    a_3 = sqrt(a_3)

    m_w1 = w1/a_1
    m_c2 = c2/a_2
    m_c3 = c_a_3/a_3
    @f3 = f_3
    @lam_3 = lam_3
    @r3 = r_sr_otn_3





    if print
      puts "l_z = "+okr(@l_z,3).to_s
      puts "h_ad = "+okr(@h_ad,3).to_s
      puts "pi_k = "+okr(@pi,3).to_s
      puts "C_u_otn_1 = "+okr(c_u_otn_1,3).to_s+"|| C_a_otn_1 = "+okr(c_a_otn_1,3).to_s
      puts "C_u_3_otn = "+okr(c_u_3_otn,3).to_s+"|| C_a_3_otn = "+okr(c_a_3_otn,3).to_s
      puts "F_1 = "+okr(f_1,3).to_s+"|| F_3 = "+okr(f_3,3).to_s
      puts "h_lopatky_3 = "+okr((500*(d_per_3 - d_vt_3)),3).to_s
      puts "D_vt_3 = "+okr(d_vt_3,3).to_s+"|| D_per_3 = "+okr(d_per_3,3).to_s+"|| D_sr_3 = "+okr((0.5*(d_per_3+d_vt_3)),3).to_s
      puts "D_otn_1 = "+okr(d_otn,3).to_s+"|| D_otn_3 = "+okr(d_otn_3,3).to_s

      puts "lambda_1 = "+okr(lam_vh,3).to_s+"|| lambda_2 = "+okr(lam_2,3).to_s+"|| lambda_3 = "+okr(lam_3,3).to_s
      puts "alfa1 = "+okr((alfa_1*180.0/3.14),3).to_s+"|| alfa2 = "+okr((alfa2*180/3.14),3).to_s+" || alfa3 = "+okr((alfa_3*180.0/3.14),3).to_s
      puts "beta1 = "+okr((beta1*180.0/3.14),3).to_s+" || beta2 = "+okr((beta2*180.0/3.14),3).to_s+" || beta3 = "+okr((beta3*180.0/3.14),3).to_s
      puts "w1 = "+okr(w1,3).to_s+"|| w2 = "+okr(w2,3).to_s+"|| w3 = "+okr(w3,3).to_s
      puts "eps_rk = "+okr((eps_rk*180/3.14),3).to_s+"|| eps_na = "+okr((eps_na*180/3.14),3).to_s
      puts "t1_stat = "+okr(t1,3).to_s+"|| t2_stat = "+okr(t2,3).to_s+"|| t3_stat = "+okr(t3,3).to_s
      puts "lam_2 = "+okr(lam_2,3).to_s
      puts "m_w1 = "+okr(m_w1,3).to_s+"|| m_c2 = "+okr(m_c2,3).to_s+"|| m_c3 = "+okr(m_c3,3).to_s
    end
  end
end

#class Stage
#end