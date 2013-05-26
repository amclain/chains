require "#{$lib}/chains/section"

module Chains
  class Document
    
    def initialize(programName = nil)
      @sections = {
        :programName  => Chains::Section.new(self, :programName),
        :header       => Chains::Section.new(self, :header),
        :devices      => Chains::Section.new(self, :devices),
        :constants    => Chains::Section.new(self, :constants),
        :includes     => Chains::Section.new(self, :includes),
        :structures   => Chains::Section.new(self, :structures),
        :variables    => Chains::Section.new(self, :variables),
        :functions    => Chains::Section.new(self, :functions),
        :events       => Chains::Section.new(self, :events)
      }
      
      # Create section headers.
      @sections.each do |key, section|
        title = ''
        
        case section.name
        when :devices
          title = 'DEVICES'
        when :constants
          title = 'CONSTANTS'
        when :includes
          title = 'INCLUDES'
        when :structures
          title = 'STRUCTURES'
        when :variables
          title = 'VARIABLES'
        when :functions
          title = 'FUNCTIONS'
        when :events
          title = 'EVENTS'
        else
          next 
        end
        
        section.header = Chains::Section.make_header title
      end
    end
    
    def [](section)
      @sections[section]
    end
    
    def to_s
      out  = ''
      
      out += @sections[:header].to_s
      out += @sections[:programName].to_s
      out += @sections[:devices].to_s
      out += @sections[:constants].to_s
      out += @sections[:includes].to_s
      out += @sections[:structures].to_s
      out += @sections[:variables].to_s
      out += @sections[:functions].to_s
      out += @sections[:events].to_s
      
      out
    end
    
  end
end
