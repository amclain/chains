require "#{$lib}/chains/element"
require "#{$lib}/chains/program_name"
require "#{$lib}/chains/writer"

module Chains
  class Document < Chains::Element
    attr_accessor :programName
    attr_accessor :writer
    
    def initialize(writer = nil)
      super()
      @writer = writer || Chains::Writer.new(self)
    end
    
    def to_s
      @writer.to_s
    end
    
  end
end
