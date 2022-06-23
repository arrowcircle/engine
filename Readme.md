# GTEngine
[![Build Status](https://travis-ci.org/arrowcircle/engine.png?branch=master)](https://travis-ci.org/arrowcircle/engine)
[![Code Climate](https://codeclimate.com/github/arrowcircle/engine.png)](https://codeclimate.com/github/arrowcircle/engine)

Math models of gas turbine engine and its parts made with ruby language

## Inspiration

https://proptools.readthedocs.io/
https://github.com/MRod5/pyturb
https://github.com/aseylys/CompPy
https://github.com/GTSL-UC/PY-C-DES
!!! https://tespy.readthedocs.io/en/dev/_modules/tespy/components/turbomachinery/compressor.html

## Usage

Add gem to your gemfile

    gem 'gtengine'

and run

    bundle

### Simple

For simple parts calculation:

    gas = Gtengine::Gas.new(300, 101325)

    k = Gtengine::Simple::Compressor.new(gas, 4.5)
    b = Gtengine::Simple::Burner.new(k.output, 1500)
    t = Gtengine::Simple::Turbine.new(b, k.l_k)

    k.info; b.info; t.info

To play with cycle (compressor -> burner -> turbine)

    require_relative 'lib/gtengine'
    gas = Gtengine::Gas.new(300, 101325)

    c = Gtengine::Simple::Cycle.new(gas, 20, 1500.0)

    c.compressor.info; c.burner.info; c.turbine.info; c.info

To play with pi_k optimization

    require_relative 'lib/gtengine'
    gas = Gtengine::Gas.new(300, 101325)

    opt = Gtengine::Simple::PikOptimizer.new(gas, 3, 40, 1500, 1)
    opt.info

Cycle research with T_g and pik

    require_relative 'lib/gtengine'
    gas = Gtengine::Gas.new(300, 101325)

    res = [900, 1000, 1100, 1200, 1300, 1400, 1500].inject({}) do |memo, t_g|
      opt = Gtengine::Simple::PikOptimizer.new(gas, 3, 40, t_g, 1)
      memo.merge(t_g.to_s => opt.optimal.pi_k)
    end
    puts res

## Compressor

Compressor initializer gets 3 arguments as input:

    Gtengine::Simple::Compressor.new(gas, pi_k, options)

where:

* gas - is gas state, as `Gtengine::Gas` class
* pi_k - is pi_k
* options - is a hash of options, defaults are:

```
    DEFAULTS = {
      kpd: 0.85
    }
```

## Burner

Burner initializer gets 3 arguments as input:

    Gtengine::Simple::Burner.new(gas, t_g, options)

where:

* gas - is gas state, as `Gtengine::Gas` class
* t_g - is t_g
* options - is a hash of options, defaults are:

```
    DEFAULTS = {
      t_0: 288.3,
      q_n: 43000000.0,
      eta_g: 0.985,
      l_0: 14.7
    }
```

## Turbine

Turbine initializer gets 3 arguments as input:

    Gtengine::Simple::Turbine.new(burner, l_k, options)

where:

* burner - is burner, as `Gtengine::Simple::Burner` class
* l_k - is l_k
* options - is a hash of options, defaults are:

```
    DEFAULTS = {
      eta: 0.9,
      eta_m: 0.985,
      g_ohl: 0.001,
      kpd: 0.9
    }
```

## Requirements

	* Ruby 2.0.0 or newer

### Copyright

Copyright © __2014__ __Oleg Bovykin__. See [LICENSE]() for details.
