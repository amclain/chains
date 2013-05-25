$root = File.dirname(__FILE__)
$lib = "#{$root}/lib"

require 'pry'
require "#{$lib}/netlinx/document"
require "#{$lib}/netlinx/element/device"
require "#{$lib}/netlinx/element/event"
require "#{$lib}/netlinx/element/function"
require "#{$lib}/netlinx/element/include"
require "#{$lib}/netlinx/element/ternary"

doc = NetLinx::Document.new 'Test Program'

e = NetLinx::Event.new :button
doc[:events] << e

e.add_device 'dvTP', 'CHAN_1'
e.add_device 'dvTP', 'CHAN_2'

push = NetLinx::EventHandler.new :push
e << push 

push << NetLinx::Ternary.new('x > 5', 3, 17, 'i')


f = NetLinx::Function.new 'my_function', 'integer index', 'sinteger'
doc[:functions] << f


f << NetLinx::Ternary.new('x', 1, 0, 'i')


dps = NetLinx::Device.new :dvTP, '10001:1:0'
doc[:devices] << dps

doc[:includes] << NetLinx::Include.new('amx-lib-volume')


puts doc
