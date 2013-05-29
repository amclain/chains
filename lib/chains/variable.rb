require "#{$lib}/chains/element"

module Chains
  class Variable < Chains::Element
    attr_accessor :symbol
    attr_accessor :type
    attr_accessor :value
    attr_accessor :size
    
    def initialize(symbol, type, value = nil, size = nil)
      super()
      
      @symbol = symbol
      @type = type
      @value = value
      @size = size
    end
    
    def empty?
      @symbol.nil? || @type.nil? || @symbol.empty? || @type.empty?
    end
    
    def to_s
      out  = ''
      out += "#{type} #{@symbol}"
      
      # Size could be an array for defining multi-dim arrays.
      if @size.class == Array
        @size.each do |s|
          out += "[#{s}]"
        end
      elsif @size
        out += "[#{size}]"
      end
      
      out += " = #{value}" if @value
      out += ' ' + @comment.to_s if @comment
      out += "\n"
      out
    end
  end
end