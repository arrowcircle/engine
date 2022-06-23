def getcp(k,r)
  cp = r*k/(k-1)
  return cp
end
def get_real_cp(t,alfa)
  if t < 750
    cp = (0.0174/alfa + 0.2407 +(0.0193+0.0093/alfa)*(0.001*2.5*t -0.875) + (0.002 - 0.001*1.056/(alfa - 0.2))*(2.5*0.00001*t**2 - 0.0275*t + 6.5625))*4187
  else
    cp = (0.0267/alfa + 0.26+(0.032 + 0.0133/alfa)*(0.001*1.176*t-0.88235) - (0.374*0.01 + 0.0094/(alfa**2+10))*(5.5556*0.000001*t**2 - 1.3056*0.01*t+6.67))*4187
  end
  return cp
end
def get_sr_cp(t,alfa)
  if t < 700
    cp = (((2.25+1.2*alfa)/(alfa*100000))*(t-70)+0.236)*4187
  else
    cp = (((1.25+2.2*alfa)/(alfa*100000))*(t+450)+0.218)*4187
  end
  return cp
end
def get_alfa(tk)
  alfa = 1.577*0.0000001*tk**2.383+1.774
  return alfa
end

def get_q(lambda,k)
  a = (k+1.0)/2.0
  a = a**(1/(k-1))
  b = (1-((k-1)/(k+1))*(lambda**2))
  b = b**(1/(k-1))
  return a*b*lambda
end

def get_eps(lambda,k)
  b = (1-((k-1)/(k+1))*(lambda**2))
  b = b**(1/(k-1))
  return b
end

def get_tau(lambda,k)
  a = (1-((k-1)/(k+1))*(lambda**2))
  return a
end

def get_a(k,r,t)
  a = sqrt((2*k*r*t)/(k+1))
  return a
end


def okr(a,num)
  num.times do
    a = a*10
  end
  a = (a.to_i).to_f
  a = a/(10**num)
end

def get_m(k)
  m = (2/(k+1))**((k+1)/(k-1))
  m = sqrt(k*m)
end

def get_d_sr(d1,d2)
  a = d1**2 + d2**2
  a = a/2
  a = sqrt(a)
  return a
end

def get_value(current, max, prop)
  case current
  when 1
    return prop*0.79
  when 2
    return prop*0.85
  when 3
    return prop*0.92
  when 4
    return prop*0.97
  #when max
  #  return prop*0.79
  #when max-1
  #  return prop*0.85
  #when max-2
  #  return prop*0.92
  #when max-3
  #  return prop*0.97
  else
    return prop
  end
end

def get_c_a(current, max, prop)
  case current
  when max
    return (prop - 20.0)
  when max-1
    return (prop-15.0)
  when max-2
    return (prop - 10.0)
  when max-3
    return (prop-5.0)
  else
    return prop
  end

end