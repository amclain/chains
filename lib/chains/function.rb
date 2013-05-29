require "#{$lib}/chains/element"

module Chains
  class Function < Chains::Element
    attr_accessor :symbol
    attr_accessor :params
    attr_accessor :type
    
    def initialize(symbol, params = nil, type = nil)
      super()
      
      @symbol = symbol
      @params = params
      @type = type
    end
    
    def empty?
      @symbol.nil? || @symbol.empty?
    end
    
    def to_s
      out  = ''
      out += "#{type} " if @type
      out += "#{@symbol}"
      out += " #{params}" if @params
      out += " ->" 
      out += ' ' + @comment.to_s if @comment
      
      @children.each {|child| out += "#{child.to_s}"}
      @siblings.each {|sibling| out += "#{sibling.to_s}"}
      
      out += "\n"
      out
    end
  end
end