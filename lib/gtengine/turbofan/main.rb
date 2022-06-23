# To change this template, choose Tools | Templates
# and open the template in the editor.
include Math
require 'compressor.rb'
require 'properties.rb'
require 'turbine.rb'
require 'nozzle.rb'
require 'cycle.rb'

def find_optimum(tg,pa,mah,ta,sm,em,spi,epi,pp)
#def find_optimum(tg,pa,mah,ta,sv,ev,spi,epi,pp)
    @min_cr = 1
    @min_pi_vl = 1.0
    @min_pi = 10
    @min_r = 1
    @min_m = 1

    for m in (5..10) do
      s = Cycle.new(tg,pa,m,0,mah,ta,pp)
      puts "##########"
      puts "m = "+(m).to_s
      for pi_vl in (13..19) do
        cr,r = s.calc(40.0,pi_vl/10.0)
        puts pi_vl.to_s + "     "+(cr).to_s
      end
    end
end
    #@min_m = 10.0
##    for m in (sm*10..em*10) do
    #for m in (sv*10..ev*10) do
    #for m in ((sm*10).to_i..(em*10).to_i) do
  #    s = Cycle.new(tg,pa,m/10.0,0,mah,ta,pp)
      #s = Cycle.new(tg,pa,@min_m,0,mah,ta,pp)
  #    puts "##########"
  #    puts "m = "+(m/10.0).to_s
  #    puts "##########"
      #puts "pi_vl = "+(pi_vl/100.0).to_s
  #    for pi in (spi..epi) do

  #      cr,r = s.calc(pi)
         #puts pi.to_s + "     "+(100.0*cr).to_s+"     "+r.to_s+ "      "+(s.tv.p_t/pa).to_s
  #       puts pi.to_s + "     "+(cr).to_s
         #puts pi.to_s + "     "+(100.0*cr).to_s+"     "+r.to_s

  #       if cr < @min_cr
  #        @min_cr = cr
  #        @min_pi = pi
         # @min_pi_vl = pi_vl/100.0
  #        @min_m = m/10.0
  #        @min_r = r
  #       end

        

      #puts pi.to_s + "     "+(((100000.0*cr).to_i)/100000.0).to_s+"     "+r.to_i.to_s+ "      "+(s.tv.p_t/pa).to_s
      #puts pi.to_s + "     "+(((100000.0*cr).to_i)/100000.0).to_s+"     "+r.to_i.to_s+"     "+(((s.v.pi_k*10000).to_i)/10000.0).to_s
  #    end
  #  end
  #  return Optimum.new(@min_cr,  @min_pi, @min_r, @min_m, @min_pi_vl)
#end

opt = find_optimum(1800,101500,0,288,13,19,15,45,1.0)
#opt = find_optimum(1800,101500,0,288,4,10,15,45,1.0)
#opt.show
#puts opt.pi_vl
#cycle = Cycle.new(1800, 101500, 8.0, 0, 0, 288,1.8)
cycle = Cycle.new(1800, 101500, 10, 0, 0, 288,1.9)
#@min_cr = 2
#@min_pi_vl = 1.0
#for pi_vl in (110..180) do
#  cr,r = cycle.calc(40,pi_vl.to_f/100.0)
#  if cr < @min_cr
#          @min_cr = cr
#          @min_pi_vl = pi_vl.to_f/100.0
#  end
#nd

#puts "opt_pi_vl = "+@min_pi_vl.to_s
#puts "min cr = "+@min_cr.to_s

#cr,r = cycle.calc(opt.piks, opt.pi_vl)
#cr,r = cycle.calc(40,@min_pi_vl)
#cr,r = cycle.calc(39,1.5)
#cycle.v.show
#cycle.p.show
#cycle.c.show
#cycle.tc.show
#cycle.tv.show
#puts "pi_s1 = "+cycle.n1.pi_s.to_s
#puts "pi_s2 = "+cycle.n2.pi_s.to_s
#puts "cr = "+cr.to_s
#puts "r = "+r.to_s
#puts "r2 = "+cycle.r2.to_s
#puts "r1 = "+cycle.r1.to_s
#puts "c2 = "+cycle.n2.cc.to_s
#puts "c1 = "+cycle.n1.cc.to_s
#puts "c2/c1"" = "+(cycle.n2.cc/cycle.n1.cc).to_s
#puts "kpd_vl*kpd_tv = "+(cycle.tv.eta*cycle.v.eta).to_s
#puts "c2_new = "+(cycle.tv.eta*cycle.v.eta*cycle.n1.cc).to_s
#puts "###########"
#g1 = 18000/r
#puts "g1 = "+g1.to_s
#g2 = 8.0*g1
#g = g1+g2
#puts "g2 = "+g2.to_s
#puts "g_sum = "+g.to_s
#a = sqrt(1.4*287.0*288.3)
#puts "a = "+a.to_s
#d2 = sqrt((4*g)/(0.91*3.14*1*200))
#puts "D2 = "+d2.to_s
#puts "D1 = "+(0.3*d2).to_s
#puts "W1 = "+sqrt(500*500+200*200).to_s
#puts "n2 = "+((1000/d2)*30/3.14).to_s
##puts get_sr_cp(861.8,10000000000)
#puts "######################################"
#puts "######################################"
#puts "######################################"
#cycle.c.calc = Calc.new(cycle.c,60.8,1,390)
#cycle.p.calc = Calc.new(cycle.p,66.04,0,260)

