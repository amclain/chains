require "#{$lib}/chains/element"

module Chains
  class Verbatim < Chains::Element
    attr_accessor :text
    
    def initialize(parent, text = nil)
      super parent
      @text = text
    end
    
    def to_s
      out  = ''
      out += @text if @text
      out += ' ' + @comment.to_s if @comment
      out
    end
  end
end