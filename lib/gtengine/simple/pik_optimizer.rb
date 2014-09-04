class Gtengine::Simple::PikOptimizer
  attr_accessor :start_pik, :end_pik, :t_g, :step, :optimum, :cycles, :air

  def initialize(air, start_pik, end_pik, t_g, step = 1)
    @air, @start_pik, @end_pik, @t_g, @step = air, start_pik, end_pik, t_g, step
    @cycles = []
    optimize
  end

  def optimize
    Range.new(start_pik, end_pik).step(step).each do |pik|
      calc_result(pik)
    end
  end

  def calc_result(pik)
    c = Gtengine::Simple::Cycle.new(air, pik, t_g)
    @cycles << c if c.burner.q_ks
  rescue
    false
  end

  def optimal
    cycles.sort { |a, b| a.burner.q_ks <=> b.burner.q_ks }.first
  end

  def info
    cycles.each { |c| c.info }
    puts "Optimal pi_k: #{optimal.pi_k}, q_ks: #{optimal.q_ks}"
  end
end