class Gtengine::Gas
  R = 287.4
  attr_accessor :t, :p, :alfa

  def initialize(t = 300.0, p = 101325.0, alfa = 99999999.0)
    @t, @p, @alfa = t.to_f, p.to_f, alfa.to_f
  end

  def density
    p / (t * R)
  end

  def k
    k_from(cp)
  end

  def average_k
    k_from(average_cp)
  end

  def cp
    return low_temperature_cp if t < 750.0
    high_temperature_cp
  end

  def average_cp
    return low_temperature_average_cp if t < 700.0
    high_temperature_average_cp
  end

  private

  def k_from(c_p)
    c_p / (c_p - R)
  end

  def high_temperature_cp
    (first_high_cp - second_high_cp * third_high_cp) * 4187.0
  end

  def first_high_cp
    0.0267 / alfa + 0.26 + (0.032 + 0.0133 / alfa) * (0.001 * 1.176 * t - 0.88235)
  end

  def second_high_cp
    0.374 * 0.01 + 0.0094 / (alfa ** 2.0 + 10.0)
  end

  def third_high_cp
    5.5556 * 0.000001 * t ** 2.0 - 1.3056 * 0.01 * t + 6.67
  end

  def low_temperature_cp
    (first_low_cp + second_low_cp * third_low_cp) * 4187.0
  end

  def first_low_cp
    0.0174 / alfa + 0.2407 + (0.0193 + 0.0093 / alfa) * (0.001 * 2.5 * t - 0.875)
  end

  def second_low_cp
    0.002 - 0.001 * 1.056 / (alfa - 0.2)
  end

  def third_low_cp
    2.5 * 0.00001 * t ** 2.0 - 0.0275 * t + 6.5625
  end

  def high_temperature_average_cp
    (((1.25 + 2.2 * alfa) / (alfa * 100000.0)) * (t + 450.0) + 0.218) * 4187.0
  end

  def low_temperature_average_cp
    (((2.25 + 1.2 * alfa) / (alfa * 100000.0)) * (t - 70.0) + 0.236) * 4187.0
  end
end