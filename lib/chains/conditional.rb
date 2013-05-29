require "#{$lib}/chains/element"

module Chains
  class Conditional < Chains::Element
    attr_accessor :type
    attr_accessor :condition
    
    def initialize(type, condition = nil)
      super()
      
      @type = type
      @condition = condition
    end
    
    def empty?
      @type.nil? || @type.empty?
    end
    
    def to_s
      out  = ''
      out += "#{@type}"
      out += " #{@condition}" if @condition
      out += ' ' + @comment.to_s if @comment
      out += "\n"
      out
    end
  end
end