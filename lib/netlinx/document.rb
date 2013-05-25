require "#{@lib}/netlinx/section"

module NetLinx
  class Document
    
    def initialize
      @sections = Array.new
    end
    
    def add_section(section)
      @sections.push section if section.is_a? NetLinx::Section
    end
    
    def to_s
      out = ''
      
      @sections.each do |section|
        out += section.to_s
      end
      
      out
    end
    
  end
end
