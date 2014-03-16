# coding: utf-8
require 'rspec'
require 'configue'

Dir.glob("#{File.dirname(__FILE__)}/support/**/*.rb") do |f|
  require f
end

RSpec.configure do |config|
end
