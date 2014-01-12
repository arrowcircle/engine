module Gtengine
  module Simple
    class Cycle
      require_relative 'simple/turbine'
      require_relative 'simple/compressor'
      require_relative 'simple/burner'
      require_relative 'simple/pik_optimizer'

      attr_accessor :air, :pi_k, :t_g, :compressor, :turbine, :burner

      def initialize air=Gas.new(300, 101325), pi_k, t_g
        @air, @t_g, @pi_k = air, t_g, pi_k
        init_cycle
      end

      def init_cycle
        @compressor = Compressor.new air, pi_k, 0.85
        @burner = Burner.new @compressor.output, t_g
        @turbine = Turbine.new burner, compressor.l_k, 0.9
      end

      def q_ks
        @burner.q_ks
      end

      def info
        puts "== Cycle info: pi_k: #{@compressor.pi_k}, q_ks: #{q_ks}"
      end
    end
  end
end