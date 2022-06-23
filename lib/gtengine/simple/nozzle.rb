class Gtengine::Simple::Nozzle
  attr_accessor :pi_s, :t, :k, :q_t, :r, :pi_kr, :cc

  def initialize(pi_s, t, k, q_t, mah, ta)
    @pi_s = pi_s
    @t = t
    @k = k
    @q_t = q_t
    @mah = mah
    @ta = ta
    @pi_kr
  end


  def get_traction1
    pi_kr = 1.89
    return 0.1 if t < 0
    return 0.1 if t > 3000
    #v = @mah*sqrt(1.4*287.2*@t)
    v = 0.0
    if ((@pi_s < 2.9)&(@pi_s > 1.0))
      cc = 2*@k/(@k-1)
      cc *= 289*@t*(1-1/(@pi_s**((@k-1)/@k)))
      return 0.1 if cc < 10
      cc = sqrt(cc)
      @cc = cc
      
      rud = (1+@q_t)*cc - v
      return rud
    else
      rud = 1
      return rud
      #сужающееся сопло
      #cc = 2*@k/(@k-1)
      #cc *= 289*@t
      #cc = sqrt(cc)
      #t_s = @t - ((@k-1)/(@k*289))*cc*cc/2
      #rud = (1+@q_t)*cc + (289*t_s/cc) - v/(1+@q_t)
      #@r = rud
      #return rud
    end
  end

  def get_traction2
    v = @mah*sqrt(1.4*287.2*@t)
    cc = 2*@k/(@k-1)
    cc *= 289*@t
    cc = sqrt(cc)
    t_s = @t - ((@k-1)/(@k*287))*cc*cc/2
    rud = (1+@q_t)*cc + (287*t_s/cc) - v/(1+@q_t)
    @r = rud
    return rud
  end
end