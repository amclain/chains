require "#{@libPath}/netlinx/element"

module NetLinx
  class EventHandler < Element
    
    def initialize(handler = nil)
      super()
      
      # Handlers: push, release, on, off, etc.
      @handler = handler
    end
    
    def to_s
      # button_event[dvTP, CH_1]
      # button_event[dvTP, CH_2]
      # {
      #   push:
      #   {
      #     doStuff();
      #   }
      # }
      
      out = ''
      
      return out unless @handler
      
      out += "#{@handler}:\n"
      out += "{\n"
      
      @elements.each do |e|
        e.to_s.each_line {|line| out += "\t#{line}"}
      end
      
      out += "}\n"
    end
    
  end
end
