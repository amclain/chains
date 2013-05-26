require "#{$lib}/netlinx/element"
require "#{$lib}/netlinx/block"

module NetLinx
  class Section < NetLinx::Element
    # Devices
    # Constants
    # Includes
    # Types
    # Variables
    # Functions
    # Events
    # Start
    # Program
    
    attr_reader :name
    
    def initialize(name = nil)
      super()
      @name = name
    end
    
    def to_s
      out = ''
      
      out += "DEFINE_#{@name.upcase}\n\n" if @name
      
      @children.each do |e|
        if e.is_a?(NetLinx::Block) && e.empty?
          out.chop!
          next
        end
        
        out += e.to_s
        out += "\n" unless e == @children.last || !e.is_a?(NetLinx::Block) 
      end
      
      out += "\n"
    end
    
  end
end
