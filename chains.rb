$root = File.dirname(__FILE__)
$lib = "#{$root}/lib"

require 'pry'
require "#{$lib}/netlinx/document"
require "#{$lib}/netlinx/assignment"
require "#{$lib}/netlinx/block"
require "#{$lib}/netlinx/event"
require "#{$lib}/netlinx/event_handler"
require "#{$lib}/netlinx/function"
require "#{$lib}/netlinx/statement"


doc = NetLinx::Document.new 'Test Program'

doc[:devices] << NetLinx::Assignment.new(:dvTP, '10001:1:0')

doc[:variables] << NetLinx::Assignment.new(:activePreset, 1, :integer)

# Event
e = NetLinx::Event.new :button
doc[:events] << e

e.add_device 'dvTP', 'BTN_1'
e.add_device 'dvTP2', 'BTN_1'

push2 = NetLinx::EventHandler.new(:push)
e << push2

push2.add_definition NetLinx::Statement.new('integer i')
push2.add_initial NetLinx::Assignment.new(:i, 0)

e << NetLinx::EventHandler.new(:release)

#Function
fn = NetLinx::Function.new('myFunction', {:i => :integer, :v => :integer}, :sinteger)
doc[:functions] << fn


puts doc
