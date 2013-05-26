$root = File.dirname(__FILE__)
$lib = "#{$root}/lib"

require 'pry'

require "#{$lib}/chains/document"


doc = Chains::Document.new 'Test Program'
doc[:header].header = Chains::Section.make_header('HEADER')

puts doc
