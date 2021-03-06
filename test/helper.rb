# require 'rubygems'
# require 'bundler'
# 
# begin
#   Bundler.setup(:default, :development)
# rescue Bundler::BundlerError => e
#   $stderr.puts e.message
#   $stderr.puts "Run `bundle install` to install missing gems"
#   exit e.status_code
# end

# require 'test/unit'
# require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'fun_with_patterns'
require 'fun_with_testing'


require_relative 'user'
require_relative 'yaml_obj'


# class Test::Unit::TestCase
# end

class FunWith::Patterns::TestCase < FunWith::Testing::TestCase
  self.gem_to_test = FunWith::Patterns
  
  include FunWith::Testing::Assertions::Basics
end