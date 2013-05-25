require "#{@lib}/netlinx/element"

module NetLinx
  class Verbatim < Element
    def initialize(text = nil)
      super()
      @text = text
    end
    
    def to_s
      @text.to_s || ''
    end
  end
end
