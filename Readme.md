# GTEngine
[![Build Status](https://travis-ci.org/arrowcircle/engine.png?branch=master)](https://travis-ci.org/arrowcircle/engine)
[![Code Climate](https://codeclimate.com/github/arrowcircle/engine.png)](https://codeclimate.com/github/arrowcircle/engine)

Math models of gas turbine engine and its parts made with ruby language

## Usage

Add gem to your gemfile

    gem 'gtengine'

and run

    bundle

### Simple

For simple parts calculation:

    gas = Gtengine::Gas.new 300, 101325

    k = Gtengine::Simple::Compressor.new gas, 4.5, 0.85
    b = Gtengine::Simple::Burner.new k.output, 1500
    t = Gtengine::Simple::Turbine.new b, k.l_k, 0.9

    k.info; b.info; t.info

To play with cycle (compressor -> burner -> turbine)

    require_relative 'lib/gtengine'
    gas = Gtengine::Gas.new 300, 101325

    c = Gtengine::Simple::Cycle.new gas, 20, 1500.0
    
    c.compressor.info; c.burner.info; c.turbine.info; c.info

To play with pi_k optimization

    require_relative 'lib/gtengine'
    gas = Gtengine::Gas.new 300, 101325
    
    opt = Gtengine::Simple::PikOptimizer.new gas, 3, 40, 1500, 1
    opt.info

Cycle research with T_g and pik

    require_relative 'lib/gtengine'
    gas = Gtengine::Gas.new 300, 101325

    res = {}
    [900, 1000, 1100, 1200, 1300, 1400, 1500].each do |t_g|
      opt = Gtengine::Simple::PikOptimizer.new(gas, 3, 40, t_g, 1)
      res[t_g.to_s] = opt.optimal.pi_k
    end
    puts res

## Requirements

	* Ruby 2.0.0 or newer

### Copyright

Copyright © __2014__ __Oleg Bovykin__. See [LICENSE]() for details.
