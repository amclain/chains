require "#{$lib}/chains/element"

module Chains
  class Comment < Chains::Element
    attr_accessor :type
    attr_reader :text
    
    def initialize(text = nil)
      super()
      self.text = text
    end
    
    def text=(value)
      @text = value
      text = value.strip
      @type = text[0, 2]
      @type += text[3] if text[3] == '^'
    end
    
    def to_s
      out  = ''
      out += @text if @text
      each_child {|e| out += e.to_s}
      each_sibling {|e| out += e.to_s}
      out += "\n" if @type == '//' || @type == '//^'
      out
    end
  end
end