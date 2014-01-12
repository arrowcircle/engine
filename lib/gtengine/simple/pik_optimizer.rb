class Gtengine::Simple::PikOptimizer
  attr_accessor :start_pik, :end_pik, :t_g, :step, :optimum, :cycles, :air

  def initialize air, start_pik, end_pik, t_g, step=1
    @air = air
    @start_pik = start_pik
    @end_pik = end_pik
    @t_g = t_g
    @step = step
    optimize
  end

  def optimize
    @cycles = []
    Range.new(start_pik, end_pik).step(step).each do |pik|
      begin
        c = Cycle.new(air, pik, t_g) 
        @cycles << c if c.burner.q_ks
      rescue
        
      end
    end
  end

  def optimal
    @cycles.sort {|a, b| a.burner.q_ks <=> b.burner.q_ks}.first
  end

  def info
    @cycles.each do |c|
      puts "pi_k: #{c.pi_k}, q_ks: #{c.q_ks}"
    end
    puts "Optimal pi_k: #{optimal.pi_k}, q_ks: #{optimal.q_ks}"
  end
end