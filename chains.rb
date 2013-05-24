@libPath = "#{File.dirname(__FILE__)}/include"
puts @libPath

require 'pry'
require "#{@libPath}/netlinx/document"
require "#{@libPath}/netlinx/element/event"
require "#{@libPath}/netlinx/element/function"
require "#{@libPath}/netlinx/element/ternary"

doc = NetLinx::Document.new

events = NetLinx::Section.new('events')
doc.add_section events
functions = NetLinx::Section.new
doc.add_section functions

e = NetLinx::Event.new(:button)
events.add_element e
e.add_device 'dvTP', 'CHAN_1'
e.add_device 'dvTP', 'CHAN_2'

push = NetLinx::EventHandler.new(:push)
 
e.add_element push 

push.add_element NetLinx::Ternary.new('x > 5', 3, 17, 'i')


f = NetLinx::Function.new('my_function', 'integer index', 'sinteger')
functions.add_element f
f.add_element NetLinx::Ternary.new('x', 1, 0, 'i')


puts doc
