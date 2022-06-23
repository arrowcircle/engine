module Gtengine
  module Simple
    class Cycle
      require_relative 'turbine'
      require_relative 'compressor'
      require_relative 'burner'

      attr_accessor :air, :pi_k, :t_g, :compressor, :turbine, :burner

      def initialize(air = Gas.new, pi_k, t_g)
        @air, @t_g, @pi_k = air, t_g, pi_k
        init_cycle
      end

      def init_cycle
        @compressor = Compressor.new(air, pi_k)
        @burner = Burner.new(@compressor.output, t_g)
        @turbine = Turbine.new(burner, compressor.l_k)
      end

      def q_ks
        burner.q_ks
      end

      def info
        puts "== Cycle info: pi_k: #{compressor.pi_k}, q_ks: #{q_ks}"
      end
    end
  end
end