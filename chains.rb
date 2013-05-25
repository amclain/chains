$root = File.dirname(__FILE__)
$lib = "#{$root}/lib"

require 'pry'
require "#{$lib}/netlinx/document"
require "#{$lib}/netlinx/element/event"
require "#{$lib}/netlinx/element/function"
require "#{$lib}/netlinx/element/ternary"

doc = NetLinx::Document.new 'Test Program'

e = NetLinx::Event.new :button
#events.add_element e
doc.add_element e, :events

e.add_device 'dvTP', 'CHAN_1'
e.add_device 'dvTP', 'CHAN_2'

push = NetLinx::EventHandler.new :push
 
e.add_element push 

push.add_element NetLinx::Ternary.new('x > 5', 3, 17, 'i')


f = NetLinx::Function.new('my_function', 'integer index', 'sinteger')
#functions.add_element f
doc.add_element f, :functions


f.add_element NetLinx::Ternary.new('x', 1, 0, 'i')


puts doc
