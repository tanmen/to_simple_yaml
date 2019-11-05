$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
Dir.glob("#{__dir__}/mocks/**/*.rb").each {|file| require file}
require "to_simple_yaml"

require "minitest/autorun"
