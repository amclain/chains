require "#{$lib}/netlinx/block"

module NetLinx
  class Event < NetLinx::Block
    attr_reader :event
    attr_reader :devchan
    
    def initialize(event = nil)
      super ''
      
      # Event type.
      @event = event.to_s
      @devchan = Array.new
    end
    
    def empty?
      @devchan.empty?
    end
    
    def +(device, channel = nil)
      add_device device, channel
      self
    end
    
    def add_device(device, channel = nil)
      # Device = device or devchan
      @devchan.push [device, channel]
    end
    
    def to_s
      @compound = ''
      @devchan.each do |devchan|
        @compound += "#{@event.downcase}_event[#{devchan[0]}"
        @compound += ", #{devchan[1]}"
        @compound += "]"
        @compound += "\n" unless devchan == @devchan.last
      end
      
      super()
    end
    
  end
end
