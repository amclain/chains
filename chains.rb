$root = File.dirname(__FILE__)
$lib = "#{$root}/lib"

require 'pry'

require "#{$lib}/chains/document"
require "#{$lib}/chains/element"

require "#{$lib}/chains/comment"


# doc = Chains::Document.new
# 
# h = <<EOS
# (!**********************************************************
    # MY CHAINS FILE
    # Example of how the Chains syntax should look.
#     
    # File extension = .axs.chains
# ************************************************************)
# EOS
# 
# header = Chains::Comment.new h
# doc << header
# 
# doc << Chains::ProgramName.new('Test Program')
# 
# puts doc

input = File.open("#{$root}/test/input.axs.chains", 'r').read

parser = Chains::Parser.new input

doc = parser.document

puts doc if doc
