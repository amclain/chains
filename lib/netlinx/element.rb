=begin
  Elements can have two relations: Children and siblings.
  Siblings are a separate block, but with no space between
  the curly braces.

  if (i > 0)      <- PARENT
  {
    doStuff(i);   <- CHILD of If
  }
  else            <- SIBLING of If
  {
    doNothing();  <- CHILD of Else
  } 
=end

module NetLinx
  class Element
    attr_accessor :children
    attr_accessor :siblings
    
    def initialize
      @children = Array.new
      @siblings = Array.new
    end
    
    def <<(e)
      add_child e
    end
    
    def ^(e)
      add_sibling e
    end
    
    def add_child(e)
      @children.push e if e.is_a? Element
    end
    
    def add_sibling(e)
      @siblings.push e if e.is_a? Element
    end
    
    def children_to_s
      out += ''
      
      @children.each do |e|
        e.to_s.each_line {|line| out += "\t#{line}"}
        out += "\n" unless e == @children.last
      end
      
      out
    end
  end
end
