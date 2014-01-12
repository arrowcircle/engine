require 'bundler/setup'
require 'rspec'

require 'gas'
require 'cycle'
Dir[Pathname.new(File.expand_path('../', __FILE__)).join('support/**/*.rb')].each {|f| require f}

