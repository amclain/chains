require "#{$lib}/chains/element"

module Chains
  class DeviceDefinition < Chains::Element
    attr_accessor :symbol
    attr_accessor :value
    attr_accessor :filePath
    
    def initialize(parent, symbol, value, filePath = nil)
      super parent
      
      @symbol = symbol
      @value = value
      @filePath = filePath
    end
    
    def empty?
      @symbol.nil? || @value.nil? || @symbol.empty? || @value.empty?
    end
    
    def to_s
      out  = ''
      out += "#{@symbol} = #{value}" 
      out += " '#{filePath}'" if @filePath
      out += ' ' + @comment.to_s if @comment
      out += "\n"
      @children.each {|e| out += "\t#{e.to_s}"}
      out
    end
  end
end