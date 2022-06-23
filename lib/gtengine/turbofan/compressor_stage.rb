include Math
require 'properties.rb'

class CompressorStage
  attr_accessor :h_t, :k_h, :eta_ad, :l_z, :delta_t, :k, :pi, :t_vh, :t_vyh, :p_vh, :p_vyh, :r, :u_p, :f3, :lam_3, :r3, :d_per, :d_vt, :d_sr, :d_otn
  def initialize(u_k, h_t_otn, k_h, eta_ad, k, t_vh, p_vh, d_otn, u_p, r, c_a, g,d_vt_vh, d_per_vh, print=false, d_vt_prot=2)

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
    c_u_otn_1 = (r_sr_otn_1*(1-@r)-h_t_otn/(2*r_sr_otn_1)).abs
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

    f_3 = f_1*get_q(lam_1,k)*p_vh*sqrt(@t_vyh)/(get_q(lam_3,k)*@p_vyh*sqrt(@t_vh))
    case d_vt_prot
    when 0
      d_vt_3 = d_vt_vh
      d_per_3 = sqrt(d_vt_3**2 + 4*f_3/3.14)
    when 2
      d_per_3 = d_vt_vh
      d_vt_3 = sqrt(d_per_3**2 - 4*f_3/3.14)
    when 1
      d_per_3 = d_vt_vh**2 + (2*f_3)/3.14
      d_per_3 = sqrt(d_per_3)
      d_vt_3 = d_vt_vh**2 - (2*f_3)/3.14
      d_vt_3 = sqrt(d_vt_3)
    end
    d_otn_3 = d_vt_3/d_per_3

    r_sr_otn_3 = sqrt((1+d_otn_3**2)/2)
    #c_u_3_otn = (r_sr_otn_3*(1-r)-h_t_otn/(2*r_sr_otn_3)).abs
    c_u_3_otn = (r_sr_otn_3*(1-r)-h_t_otn/(2*r_sr_otn_3))
    alfa_3 = (atan(c_a_3_otn/c_u_3_otn))

    #Уточняем

    lam_3 = c_a_3/(sin(alfa_3)*a_kr_3)

    f_3 = f_3*get_q(lam_1,k)/get_q(lam_3,k)

    case d_vt_prot
    when 0
      d_vt_3 = d_vt_vh
      d_per_3 = sqrt(d_vt_3**2 + 4*f_3/3.14)
    when 2
      d_per_3 = d_vt_vh
      d_vt_3 = sqrt(d_per_3**2 - 4*f_3/3.14)
    when 1
      d_per_3 = d_vt_vh**2 + (2*f_3)/3.14
      d_per_3 = sqrt(d_per_3)
      d_vt_3 = d_vt_vh**2 - (2*f_3)/3.14
      d_vt_3 = sqrt(d_vt_3)
    end
    @d_per = d_per_3
    @d_vt = d_vt_3
    @d_sr = get_d_sr(d_per_3, d_vt_3)
    @d_otn = @d_vt*@d_per
    @u_p = u_p*@d_per/d_per_vh

   
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
    t1 = @t_vh*get_tau(lam_1,k)

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
      puts "input data"
      puts "k_h = "+k_h.to_s+"| kpd = "+eta_ad.to_s+"| u_k = "+u_k.to_s+"| h_t_orn = "+h_t_otn.to_s+"| "
      puts "l_z = "+okr(@l_z,3).to_s
      puts "h_ad = "+okr(@h_ad,3).to_s
      puts "pi_k = "+okr(@pi,3).to_s
      puts "C_u_otn_1 = "+okr(c_u_otn_1,3).to_s+"|| C_a_otn_1 = "+okr(c_a_otn_1,3).to_s
      puts "C_u_3_otn = "+okr(c_u_3_otn,3).to_s+"|| C_a_3_otn = "+okr(c_a_3_otn,3).to_s
      puts "F_1 = "+okr(f_1,3).to_s+"|| F_3 = "+okr(f_3,3).to_s
      puts "h_lopatky_3 = "+okr((500*(d_per_3 - d_vt_3)),3).to_s
      puts "D_vt_3 = "+okr(d_vt_3,3).to_s+"|| D_per_3 = "+okr(d_per_3,3).to_s+"|| D_sr_3 = "+okr((0.5*(d_per_3+d_vt_3)),3).to_s
      puts "D_otn_1 = "+okr(d_otn,3).to_s+"|| D_otn_3 = "+okr(d_otn_3,3).to_s
      puts "T_vyh = "+@t_vyh.to_s
      puts "lambda_1 = "+okr(lam_1,3).to_s+"|| lambda_2 = "+okr(lam_2,3).to_s+"|| lambda_3 = "+okr(lam_3,3).to_s
      puts "alfa1 = "+okr((alfa_1*180.0/3.14),3).to_s+"|| alfa2 = "+okr((alfa2*180/3.14),3).to_s+" || alfa3 = "+okr((alfa_3*180.0/3.14),3).to_s
      puts "beta1 = "+okr((beta1*180.0/3.14),3).to_s+" || beta2 = "+okr((beta2*180.0/3.14),3).to_s+" || beta3 = "+okr((beta3*180.0/3.14),3).to_s
      puts "w1 = "+okr(w1,3).to_s+"|| w2 = "+okr(w2,3).to_s+"|| w3 = "+okr(w3,3).to_s
      puts "eps_rk = "+okr((eps_rk*180/3.14),3).to_s+"|| eps_na = "+okr((eps_na*180/3.14),3).to_s
      puts "t1_stat = "+okr(t1,3).to_s+"|| t2_stat = "+okr(t2,3).to_s+"|| t3_stat = "+okr(t3,3).to_s
      puts "m_w1 = "+okr(m_w1,3).to_s+"|| m_c2 = "+okr(m_c2,3).to_s+"|| m_c3 = "+okr(m_c3,3).to_s
      puts "C_a_1 = "+okr(c_a, 3).to_s+"|| C_a_3 = "+okr(c_a_3, 3).to_s
      puts "d_per_ch = "+okr(d_per_vh, 3).to_s+"|| d_per = "+okr(@d_per, 3).to_s
    end
  end
end