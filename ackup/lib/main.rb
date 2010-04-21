# To change this template, choose Tools | Templates
# and open the template in the editor.
include Math
require 'compressor.rb'
require 'properties.rb'
require 'turbine.rb'
require 'nozzle.rb'
require 'cycle.rb'

def find_optimum(tg,pa,mah,ta,sm,em,spi,epi,pp)
    @min_cr = 1
    @min_pi_vl = 1.0
    @min_pi = 10
    @min_r = 1
    @min_m = 1
    for m in (sm*10..em*10) do
      s = Cycle.new(tg,pa,m/10.0,0,mah,ta,pp)
      puts "##########"
      puts "m = "+(m/10.0).to_s
      for pi in (spi..epi) do
        cr,r = s.calc(pi)
        puts pi.to_s + "     "+(100.0*cr).to_s+"     "+r.to_s+ "      "+(s.tv.p_t/pa).to_s

          if cr < @min_cr
              @min_cr = cr
              @min_pi = pi
              @min_m = m/10.0
              @min_r = r
          end
      end
    end
    return Optimum.new(@min_cr,  @min_pi, @min_r, @min_m)
end

opt = find_optimum(1800,101500,0,288,4,7,15,35,2.0)
opt.show
cycle = Cycle.new(1800, 101500, opt.m, 0, 0, 288,2.0)
#cycle = Cycle.new(1800, 101500, 6.6, 0, 0, 288,2.0)
#cr,r = cycle.calc(25)
cr,r = cycle.calc(opt.piks)
#cr,r = cycle.calc(32)
cycle.v.show
cycle.p.show
cycle.c.show
cycle.tc.show
cycle.tv.show
#puts cr
#puts r