$root = File.dirname(__FILE__)
$lib = "#{$root}/lib"

require 'pry'

require "#{$lib}/chains/document"
require "#{$lib}/chains/element"


doc = Chains::Document.new 'Test Program'

puts doc
