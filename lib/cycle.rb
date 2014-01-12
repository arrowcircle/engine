# coding: utf-8
require_relative 'gas'

class Cycle
  require_relative 'cycle/turbine'
  require_relative 'cycle/compressor'
  require_relative 'cycle/burner'

  attr_accessor :air, :pi_k, :t_g, :compressor, :turbine, :burner

  def initialize air=Gas.new(300, 101325), pi_k, t_g
    @air = air
    @pi_k = pi_k
    @compressor = Compressor.new air, pi_k, 0.85
    @burner = Burner.new @compressor.output, t_g
    @turbine = Turbine.new @burner, @compressor.l_k, 0.9
  end

  def q_ks
    @burner.q_ks
  end

  def info
    puts "== Cycle info"
    puts "pi_k: #{@compressor.pi_k}, q_ks: #{q_ks}"
  end
end