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
    
  end
end
