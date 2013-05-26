module Chains
  class Element
    attr_accessor :parent
    attr_accessor :children
    attr_accessor :siblings
    
    def initialize(parent = nil)
      @parent = parent
      @children = Array.new
      @siblings = Array.new
    end
    
    def <<(e)
      add_child e
      self
    end
    
    def ^(e)
      add_sibling e
      self
    end
    
    def [](element_class)
      each_child element_class
    end
    
    def add_child(e)
      @children.push e if e.is_a? Chains::Element
    end
    
    def add_sibling(e)
      @siblings.push e if e.is_a? Chains::Element
    end
    
    def empty?
      !children? && !siblings?
    end
    
    def children?
      !@children.empty?
    end
    
    def siblings?
      !@siblings.empty?
    end
    
    def each_child(element_class = nil, &block)
      if element_class
        r = @children.select {|e| e.is_a? element_class}.each(&block)
      else
        r = @children.each(&block)
      end
      r.each
    end
    
    def each_sibling(element_class = nil)
      if element_class
        r = @siblings.select {|e| e.is_a? element_class}.each(&block)
      else
        r = @siblings.each(&block)
      end
      r.each
    end
      
  end
end
