$root = File.dirname(__FILE__)
$lib = "#{$root}/lib"

require 'pry'

require "#{$lib}/netlinx/document"

require "#{$lib}/netlinx/assignment"
require "#{$lib}/netlinx/block"
require "#{$lib}/netlinx/conditional"
require "#{$lib}/netlinx/device"
require "#{$lib}/netlinx/event"
require "#{$lib}/netlinx/event_handler"
require "#{$lib}/netlinx/function"
require "#{$lib}/netlinx/statement"


programName = 'Test Program'

header = <<EOS
(***********************************************************
    #{programName}
    
    This file was automatically generated.
    The original code was written in CHAINS.
    
    http://sourceforge.net/projects/chains
************************************************************)
EOS

doc = NetLinx::Document.new programName, header

doc[:devices] << NetLinx::Device.new(:dvTP, 10001, 1, 0)
doc[:devices] << NetLinx::Device.new(:dvTP2, 10002)

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

cond = NetLinx::Conditional.new(:if, 'i > 5')
fn << cond
cond << NetLinx::Statement.new('doStuff()')

cnd2 = NetLinx::Conditional.new(:elseif, 'x == 1')
cond ^ cnd2
cnd2 << NetLinx::Statement.new('doOtherStuff()')

els  = NetLinx::Block.new(:else)
cond ^ els
els << NetLinx::Statement.new('doNothing()')

puts doc
