=begin
  Code Block:
  Symbol, expression, or compound group on first line.
  Opening and closing curly braces wrap children.
  
  define_function integer add(integer a, integer b)
  {
    // Definitions
    integer i;
    
    // Initial
    i = 0;
    
    // Child
    doStuff(i);
    
    // Final
    return i;
  }
  
  for (i = 0; i < 10; i++)
  {
    // Child
    doStuff(i);
    
    // Final
    if (x == true) break;
  }
  
  push:
  {
      doStuff();
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
  attr_accessor :definitions
  attr_accessor :initial
  attr_accessor :final
  
  class Block < NetLinx::Element
    def initialize(compound)
      super()
      @compound = compound
      
      @definitions = Array.new
      @initial = Array.new
      @final = Array.new
    end
    
    def empty?
      @compound == nil || @compound.strip.empty? ? true : false
    end
    
    def add_definition(e)
      @definitions.push e
    end
    
    def add_initial(e)
      @initial.push e
    end
    
    def add_final(e)
      @final.push e
    end
    
    def to_s
      out = "#{@compound.to_s}\n"
      out += "{\n"
      
      @definitions.each do |definition|
        definition.to_s.each_line {|line| out += "\t#{line}"}
      end
      out += "\n" if !@definitions.empty? && !@initial.empty?
      
      @initial.each do |initial|
        initial.to_s.each_line {|line| out += "\t#{line}"}
      end
      out += "\n" if !@initial.empty? && !@children.empty?
      
      @children.each do |child|
        child.to_s.each_line {|line| out += "\t#{line}"}
        
        # Add a space between event handlers.
        out += "\n" if child.is_a?(EventHandler) && child != @children.last
      end
      out += "\n" if !@children.empty? && !@final.empty?
      
      @final.each do |final|
        final.to_s.each_line {|line| out += "\t#{line}"}
      end
      
      out += "}\n"
      
      
      @siblings.each do |sibling|
        out += sibling.to_s
      end
      
      out
    end
  end
end
