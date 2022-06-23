include Math
require 'properties.rb'
require 'compressor_stage.rb'

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
  def initialize(comp,g,d_const, u_pk)
    #puts g
    #d_const = 1
    #Коэффициент теоретического напора средней ступени
    h_tk_sr_otn = 0.32
    #средняя окружная скорость на периферии компрессора
    u_pk_sr = u_pk
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
    d_otn_1 = 0.845
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
    f1 = g*sqrt(287*comp.t_vh)/(get_m(comp.k)*get_q(lam_kr_1,comp.k)*p_1)
    f_vyh = g*sqrt(287*comp.t_k)/(get_m(comp.k)*get_q(lam_kr_vyh,comp.k)*p_vyh)
    puts "F1 = "+okr(f1,3).to_s+" || F2 = "+okr(f_vyh,3).to_s
    #Диаметры первой и последней ступени компрессора
    d_p_1 = 60.0*u_pk_sr/(3.14*n)
    d_vt_1 = d_p_1*d_otn_1

    d_sr_1 = get_d_sr(d_p_1,d_vt_1)
    #для Д_втулки = конст
    #d_vt_vyh = d_vt_1
    #d_p_vyh = d_vt_vyh**2 + (4*f_vyh)/3.14
    #d_p_vyh = sqrt(d_p_vyh)
    #Для Д_пер = конст
    case d_const
    when 2
      d_p_vyh = d_p_1
      d_vt_vyh = d_p_vyh**2 - (4*f_vyh)/3.14
      d_vt_vyh = sqrt(d_vt_vyh)
      d_sr_vyh = get_d_sr(d_p_vyh,d_vt_vyh)
    when 0
      d_vt_vyh = d_vt_1
      d_p_vyh = d_vt_vyh**2 + (4*f_vyh)/3.14
      d_p_vyh = sqrt(d_p_vyh)
      d_sr_vyh = get_d_sr(d_p_vyh,d_vt_vyh)
    when 1
      d_sr_vyh = d_sr_1
      d_p_vyh = d_sr_vyh**2 + (2*f_vyh)/3.14
      d_p_vyh = sqrt(d_p_vyh)
      d_vt_vyh = d_sr_vyh**2 - (2*f_vyh)/3.14
      d_vt_vyh = sqrt(d_vt_vyh)

    end
    
    #d_p_vyh = d_p_1
    
    #d_vt_vyh = d_p_vyh**2 - (4*f_vyh)/3.14
    #d_vt_vyh = sqrt(d_vt_vyh)
    
    
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
    k_h = [0.995,0.99,0.988,0.985,0.983,0.98, 0.98, 0.98, 0.98, 0.98, 0.98, 0.97,0.97, 0.97, 0.97,0.97]
    kpd = [0.865,0.875,0.885,0.89,0.89,0.88, 0.875, 0.87, 0.865, 0.86, 0.855, 0.85, 0.845, 0.84, 0.835, 0.83]
    h_t_oo = [0.26, 0.28,0.3 ,0.31 , 0.32, 0.325, 0.33, 0.33,0.33,0.33, 0.33, 0.33, 0.32, 0.31, 0.28, 0.26]
    #Stage.initialize(h_t, h_t_otn, k_h, eta_ad, k, t_vh, p_vh, d_otn, u_p, r, c_a,lam_vh, f_1,d_vt_vh, print=false)
    puts "##########Stage 1############"
    #d_vt=const
    #
    #d_per=cons
    #для коэф теор напора
    #get_value(1,@z,0.33)
    #для кпд
    #get_value(1,@z,0.9)

    @z = (@z.to_i)
    case d_const
    when 2
      stages << CompressorStage.new(u_pk_sr,get_value(1,@z,0.37),k_h[0],get_value(1,@z,0.9),comp.k,comp.t_vh,p_1,d_otn_1, u_pk_sr, 0.65,ca_1,g,d_p_1,d_p_1, true, 2)
    when 0
      stages << CompressorStage.new(u_pk_sr,get_value(1,@z,0.37),k_h[0],get_value(1,@z,0.9),comp.k,comp.t_vh,p_1,d_otn_1, u_pk_sr, 0.65,ca_1,g,d_vt_1,d_p_1, true, 0)
    when 1
      stages << CompressorStage.new(u_pk_sr,get_value(1,@z,0.37),k_h[0],get_value(1,@z,0.9),comp.k,comp.t_vh,p_1,d_otn_1, u_pk_sr, 0.65,ca_1,g,d_sr_1,d_p_1, true, 1)
    end
    for i in 1..@z do
      puts "##########Stage "+(i+1).to_s+"############"
      #d_vt=const
      #stages << Stage.new(u_pk_sr,0.37,k_h[i],kpd[i],comp.k,stages[-1].t_vyh,stages[-1].p_vyh,d_otn_1, u_pk_sr, 0.65,ca_1,stages[-1].lam_3,g,d_vt_1, true, false)
      #d_per=const
      case d_const
      when 2
        stages << CompressorStage.new(u_pk_sr,get_value(i,@z,0.37),k_h[i],get_value(i,@z,0.9),comp.k,stages[-1].t_vyh,stages[-1].p_vyh,stages[-1].d_otn, stages[-1].u_p, 0.65,get_c_a(i,@z,ca_1),g,d_p_1, stages[-1].d_per, true, 2)
      when 0
        stages << CompressorStage.new(u_pk_sr,get_value(i,@z,0.37),k_h[i],get_value(i,@z,0.9),comp.k,stages[-1].t_vyh,stages[-1].p_vyh,stages[-1].d_otn, stages[-1].u_p, 0.65,get_c_a(i,@z,ca_1),g,d_vt_1, stages[-1].d_per, true, 0)
      when 1
        stages << CompressorStage.new(u_pk_sr,get_value(i,@z,0.37),k_h[i],get_value(i,@z,0.9),comp.k,stages[-1].t_vyh,stages[-1].p_vyh,stages[-1].d_otn, stages[-1].u_p, 0.65,get_c_a(i,@z,ca_1),g,d_sr_1, stages[-1].d_per, true, 1)
      end
    end
    pi_k = stages[-1].p_vyh/stages[0].p_vh
    puts "pi_k = "+okr((stages[-1].p_vyh/stages[0].p_vh),4).to_s
    kpd_la = (pi_k**((comp.k-1)/comp.k)-1)*stages[0].t_vh
    kpd_la = kpd_la/(stages[-1].t_vyh-stages[0].t_vh)
    puts "kpd_la = "+okr(kpd_la,4).to_s
    #puts "protochka d_per"
    @lz = 0
    for stage in stages
      @lz = @lz + stage.l_z
    end
    puts "N_KVD = "+(g*@lz).to_s
    comp.stages = stages
    #puts "protochka d_vt"
    #for stage in stages
    #  puts stage.d_vt
    #end
    #puts "h lopaty"
    #for stage in stages
    #  puts 0.5*(stage.d_per - stage.d_vt)
    #end


  end

end




#class Stage
#end