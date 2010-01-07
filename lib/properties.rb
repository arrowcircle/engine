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