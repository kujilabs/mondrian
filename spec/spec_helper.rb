require 'bundler'
Bundler.require :default, :test

require 'mondrian'
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

  # config.include(CustomMatchers)

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end
