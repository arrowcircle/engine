module Gtengine::Defaults
  def method_missing(m, *args, &block)
    if defined?(options) && options.has_key?(m.to_sym)
      options[m.to_sym]
    else
      super
    end
  end
end
