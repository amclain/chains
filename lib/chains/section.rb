require "#{$lib}/chains/element"

module Chains
  class Section < Chains::Element
    attr_accessor :name
    attr_accessor :header
    
    def initialize(name = nil, header = nil)
      super()
      @name = name
      @header = header
    end
    
    def self.make_header(title)
      out  = "(^**********************************************************)\n"
      out += "(^ #{title.center 55} *)\n"
      out += "(^**********************************************************)\n"
    end
    
    def to_s
      out  = ''
      out += @header + "\n" if @header
      out += "\n" unless name == :footer
      out
    end
    
  end
end