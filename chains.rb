$root = File.dirname(__FILE__)
$lib = "#{$root}/lib"

require 'pry'
require "#{$lib}/netlinx/document"
require "#{$lib}/netlinx/element/device"


doc = NetLinx::Document.new 'Test Program'



puts doc
