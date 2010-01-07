# To change this template, choose Tools | Templates
# and open the template in the editor.
include Math
require 'compressor.rb'
require 'properties.rb'
require 'turbine.rb'


c = Compressor.new(101500, 288, 3, 0.86)
c.show
t = Turbine.new(c.pi_k, 1650, 0.9, c, 0.024, 2.0, 2, 0.1, 0.985)
t.show