require "#{$lib}/netlinx/block"

module NetLinx
  class EventHandler < NetLinx::Block
    
    def initialize(handler)
      super ''
      
      # Handlers: push, release, on, off, etc.
      @handler = handler
    end
    
    def empty?
      @handler.nil? || handler.to_s.empty?
    end
    
    def to_s
      @compound = @handler.to_s.delete(':') + ':'
      super
    end
    
  end
end
