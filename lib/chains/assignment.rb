require "#{$lib}/chains/element"

module Chains
  class Assignment < Chains::Element
    attr_accessor :text
    
    def initialize(parent, symbol, value)
      super parent
      
      @symbol = symbol
      @value = value
    end
    
    def to_s
      out  = ''
      out += @text if @text
      out += ' ' + @comment.to_s if @comment
      out
    end
  end
end