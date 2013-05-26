require "#{$lib}/chains/element"
require "#{$lib}/chains/program_name"
require "#{$lib}/chains/parser"
require "#{$lib}/chains/writer"

module Chains
  class Document < Chains::Element
    attr_accessor :programName
    attr_accessor :writer
    
    def initialize(writer = nil)
      super()
      @writer = writer || Chains::Writer.new(self)
    end
    
    def self.parse(input)
      p = Chains::Parser.new
      p.parse input
    end
    
    def to_s
      @writer.to_s
    end
    
  end
end
