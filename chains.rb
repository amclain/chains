$root = File.dirname(__FILE__)
$lib = "#{$root}/lib"

require 'pry'

require "#{$lib}/chains/parser"
require "#{$lib}/chains/netlinx_transformation"

input = File.open("#{$root}/test/input.axs.chains", 'r').read

begin
  parser = Chains::Parser.new input
  chainsDoc = parser.document
  #puts Chains::Parser.clean(chainsDoc) if chainsDoc
  netlinxDoc = Chains::NetLinxTransformation.transform chainsDoc
  puts netlinxDoc
rescue Chains::ParserException => e
  puts e.message
end
