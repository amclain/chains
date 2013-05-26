require "#{$lib}/chains/element"

module Chains
  class ProgramName < Chains::Element
    attr_accessor :text
    
    def initialize(parent, text)
      super parent
      @text = text
    end
    
    def to_s
      out  = ''
      out += "PROGRAM_NAME = '#{@text}'" if @text
      out
    end
  end
end