require "#{$lib}/chains/element"

module Chains
  class Verbatim < Chains::Element
    attr_accessor :text
    
    def initialize(text = nil)
      @text = text
    end
    
    def to_s
      out  = ''
      out += @text if @text
      out
    end
  end
end