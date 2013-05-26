require "#{$lib}/netlinx/element"

module NetLinx
  class Verbatim < NetLinx::Element
    attr_accessor :text
    
    def initialize(text = nil)
      super()
      @text = text
    end
    
    def to_s
      @text.to_s || ''
    end
  end
end
