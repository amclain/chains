require "#{$lib}/chains/element"

module Chains
  class Assignment < Chains::Element
    attr_accessor :symbol
    attr_accessor :value
    
    def initialize(parent, symbol, value)
      super parent
      
      @symbol = symbol
      @value = value
    end
    
    def empty?
      @symbol.nil? || @value.nil? || @symbol.empty? || @value.empty?
    end
    
    def to_s
      out  = ''
      out += "#{@symbol} = #{value}" 
      out += ' ' + @comment.to_s if @comment
      out += "\n"
      out
    end
  end
end