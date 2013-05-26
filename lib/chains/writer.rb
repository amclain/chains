require "#{$lib}/chains/document"

module Chains
  class Writer
    attr_accessor :document
    attr_accessor :template
    
    def initialize(document = nil, template = nil)
      @document = document
      @template = template
    end
    
    def to_s
      out = ''
      return out unless @document.is_a? Chains::Document
      
      lastClass = @document.class
      @document.each_child do |e|
        out += e.to_s
        out += "\n" if lastClass != e.class && e != @document.children.last
        lastClass = e.class
      end
      
      out
    end
    
  end
end