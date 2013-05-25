$root = File.dirname(__FILE__)
$lib = "#{$root}/lib"

require 'pry'
require "#{$lib}/netlinx/document"
require "#{$lib}/netlinx/assignment"
require "#{$lib}/netlinx/block"
require "#{$lib}/netlinx/event"
require "#{$lib}/netlinx/statement"


doc = NetLinx::Document.new 'Test Program'

doc[:devices] << NetLinx::Assignment.new(:dvTP, '10001:1:0')

doc[:variables] << NetLinx::Assignment.new(:activePreset, 1, :integer)

event = NetLinx::Block.new('button_event[dvTP, CHAN_1]')
doc[:events] << event

push = NetLinx::Block.new('push:')
event << push

cIf = NetLinx::Block.new('if (x > 5)')
cIf << NetLinx::Statement.new('doStuff()')
push << cIf
cElse = NetLinx::Block.new('else')
cElse << NetLinx::Statement.new('doNothing()')
cIf ^ cElse

release = NetLinx::Block.new('release:')
event << release


# New event
e = NetLinx::Event.new :button
doc[:events] << e

e.add_device 'dvTP', 'BTN_1'
e.add_device 'dvTP2', 'BTN_1'

e << NetLinx::Block.new('push:')

puts doc
