=begin
  Code Block -> Conditionals:
  Symbol followed by an expression in parenthesis
  Symbol and expression separated by whitespace.
  Has children.
  May have siblings.
  
  if (x > 0)
  {
      doStuff();
  }
  else if (x == 5)
  {
      doOtherStuff();
  }
  else
  {
      doNothing();
  }
  
  switch (i)
  {
    case 1
    {
    }
  }
  
  while (x > 0)
  {
  }
  
  for (i = 0; i < 10; i++)
  {
  } 
=end

require "#{$lib}/netlinx/block"

module NetLinx
  class Conditional < NetLinx::Block
    attr_reader :event
    
    def initialize(symbol, condition = nil)
      super ''
      
      # Event type.
      @symbol = symbol
      @condition = condition
    end
    
    def empty?
      @symbol.nil? || @symbol.empty?
    end
    
    def to_s
      case @symbol
      when :elseif
        @compound = 'else if'
      else
        @compound = @symbol.to_s
      end
      
      @compound += " (#{@condition.to_s})" if @condition
      
      super()
    end
    
  end
end
