=begin
  Code Block:
  Symbol, expression, or compound group on first line.
  Opening and closing curly braces wrap children.
  
  push:
  {
      doStuff();
  }
  
  define_function integer add(integer a, integer b)
  {
  }
  
  if (i > 0)
  {
  }
  
  wait 3
  {
  } 
=end


require "#{$lib}/netlinx/element"

module NetLinx
  class Block < Element
    def initialize(compound)
      super()
      @compound = compound
    end
    
    def to_s
      out = "#{@compound.to_s}\n"
      out += "{\n"
      
      @children.each do |child|
        child.to_s.each_line {|line| out += "\t#{line}"}
      end
      
      out += "}\n"
      
      @siblings.each do |sibling|
        out += sibling.to_s
      end
    end
  end
end
