require "#{$lib}/chains/element"

module Chains
  class Function < Chains::Element
    attr_accessor :symbol
    attr_accessor :params
    attr_accessor :type
    
    def initialize(parent, symbol, params = nil, type = nil)
      super parent
      
      @symbol = symbol
      @params = params
      @type = type
    end
    
    def empty?
      @symbol.nil? || @symbol.empty?
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