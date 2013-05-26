require "#{$lib}/netlinx/section"

module NetLinx
  class Document
    attr_accessor :programName
    attr_accessor :header
    attr_reader :sections
    
    def initialize(programName = nil, header = nil)
      @programName = programName
      @header = header
      
      @sections = {
        :devices => NetLinx::Section.new(:device),
        :constants => NetLinx::Section.new(:constant),
        :includes => NetLinx::Section.new(),
        :types => NetLinx::Section.new(:type),
        :variables => NetLinx::Section.new(:variable),
        :functions => NetLinx::Section.new(),
        :start => NetLinx::Section.new(:start),
        :events => NetLinx::Section.new(:event),
        :program => NetLinx::Section.new(:program)
      }
    end
    
    def [](section)
      @sections[section]
    end
    
    def to_s
      out = ''
      
      out += @header.to_s + "\n" if @header
      
      out += "PROGRAM_NAME='#{@programName}'\n" if @programName
      
      @sections.each do |name, section|
        out += "(***********************************************************)\n"
        out += "(*  #{name.to_s.upcase.center 55}*)\n"
        out += "(***********************************************************)\n"
        
        # Add an extra space to sections that don't start with a DEFINE_ symbol.
        out += "\n" if [:includes, :functions].include? name
        
        out += section.to_s
      end
      
      out += <<EOS
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*          DO NOT PUT ANY CODE BELOW THIS COMMENT         *)
(***********************************************************)
EOS
      
      # Replace tabs with 3 spaces.
      out.gsub(/\t/, '   ')
    end
    
  end
end
