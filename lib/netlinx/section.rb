require "#{$lib}/netlinx/element"

module NetLinx
  class Section
    # Devices
    # Constants
    # Includes
    # Types
    # Variables
    # Functions
    # Events
    # Start
    # Program
    
    def initialize(name = nil)
      @name = name
      @elements = Array.new
    end
    
    def <<(e)
      add_element e
    end
    
    def add_element(e)
      @elements.push e if e.is_a? NetLinx::Element
    end
    
    def to_s
      out = ''
      
      out += "DEFINE_#{@name.upcase}\n\n" if @name
      
      @elements.each do |e|
        out += e.to_s
      end
      
      out += "\n"
    end
    
  end
end
