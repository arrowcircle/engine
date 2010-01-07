# To change this template, choose Tools | Templates
# and open the template in the editor.
include Math
require 'compressor.rb'
require 'properties.rb'
require 'turbine.rb'
require 'nozzle.rb'
require 'cycle.rb'

def find_optimum(tg,pa,mah,ta,sm,em,spi,epi,spivl,epivl)
    @min_cr = 1
    @min_pi_vl = 1.1
    @min_pi = 10
    @min_r = 1
    @min_m = 1
    for m in (sm*10..em*10) do
      s = Cycle.new(tg,pa,m/10.0,0,mah,ta)
      for pi in (spi..epi) do
        for pi_vl in ((spivl*10).to_i..(epivl*10).to_i) do
          cr,r = s.calc(pi,pi_vl/10.0)
          if cr < @min_cr
           @min_cr = cr
           @min_pi_vl = pi_vl/10.0
           @min_pi = pi
           @min_m = m/10.0
           @min_r = r
          end
        end
      end
    end
    return Optimum.new(@min_cr, @min_pi_vl, @min_pi, @min_r, @min_m)
  end

opt = find_optimum(1650,101500,0,288,5,6,20,40,1.6,2.5)
opt.show
cycle = Cycle.new(1650, 101500, opt.m, 0, 0, 288)
cr,r = cycle.calc(opt.piks, opt.pi_vl)
cycle.v.show
cycle.c.show
cycle.tc.show
cycle.tv.show