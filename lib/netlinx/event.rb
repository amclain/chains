require "#{$lib}/netlinx/element"
require "#{$lib}/netlinx/element/event_handler"

module NetLinx
  class Event < NetLinx::Element
    
    def initialize(event = nil)
      super()
      
      @event = event
      @devchan = Array.new
    end
    
    def add_device(device, channel = nil)
      # Device = device or devchan
      @devchan.push [device, channel]
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
      
      return out unless @event
      return out if @devchan.empty?
      
      @devchan.each do |devchan|
        out += "#{@event}_event"
        
        if devchan[1]
          # Device + Channel
          out += "[#{devchan[0]}, #{devchan[1]}]\n"
        else
          # Devchan
          out += "[#{devchan[0]}]\n"
        end
      end
      
      out += "{\n"
      
      @elements.each do |e|
        e.to_s.each_line {|line| out += "\t#{line}"}
        out += "\n" unless e == @elements.last
      end
      
      # binding.pry
      # out += children_to_s
      
      out += "}\n"
    end
    
  end
end
