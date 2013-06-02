require "#{$lib}/chains/chains_extensions"

require "#{$lib}/netlinx/assignment"
require "#{$lib}/netlinx/block"
require "#{$lib}/netlinx/conditional"
require "#{$lib}/netlinx/device"
require "#{$lib}/netlinx/directive"
require "#{$lib}/netlinx/document"
require "#{$lib}/netlinx/event_handler"
require "#{$lib}/netlinx/event"
require "#{$lib}/netlinx/function"
require "#{$lib}/netlinx/statement"
require "#{$lib}/netlinx/verbatim"

module Chains
  class NetLinxTransformation
    attr_reader :chains_document
    attr_reader :netlinx_document
    
    def initialize(chainsDocuemnt = nil)
      @chains_document = chainsDocuemnt
      @netlinx_document = nil
      
      transform @chains_document if @chains_document
    end
    
    def self.transform(chainsDocument)
      t = Chains::NetLinxTransformation.new chainsDocument
      t.netlinx_document
    end
    
    def transform(chainsDocument = nil)
      chainsDoc = chainsDocument || @chains_document
      
      netlinxDoc = NetLinx::Document.new
      
      convert_element chainsDoc, netlinxDoc
      
      @netlinx_document = netlinxDoc
    end
    
    
    private
    def find(element, elementClass)
      return nil if element.elements.nil?
      
      result = nil
      element.elements.each do |e|
        return e if e.is_a? elementClass
      end
      
      element.elements.each do |e|
        result = find e, elementClass
        return result unless result.nil?
      end
      
      return result
    end
    
    def convert_element(e, netlinxDoc)
      #binding.pry
      
      if e.elements.nil? == false
        e.elements.each do |element|
          convert_element element, netlinxDoc
        end
      end
      
      case
      # when e.is_a?(BlockComment)
        # transform_block_comment e
      # when e.is_a?(Comment)
        # transform_comment e
      # when e.is_a?(EventDefinition)
        # t = transform_event_definition e
        # netlinxDoc[:events] << t
      # when e.is_a?(EventHandler)
        # transform_event_handler e
      # when e.is_a?(FunctionDefinition)
        # t = transform_function_definition e
        # netlinxDoc[:functions] << t
      # when e.is_a?(Conditional)
        # transform_conditional e
      when e.is_a?(ProgramName)
        t = transform_program_name e
        netlinxDoc.programName = t
      # when e.is_a?(IncludeDirective)
        # t = transform_include_directive e
        # netlinxDoc[:includes] << t
      # when e.is_a?(DeviceDefinition)
        # t = transform_device_definition e
        # netlinxDoc[:devices] << t
      # when e.is_a?(DeviceCombine)
        # transform_device_combine e
      # when e.is_a?(ConstantDefinition)
        # t = transform_constant_definition e
        # netlinxDoc[:constants] << t
      # when e.is_a?(StructureDefinition)
        # t = transform_structure_definition e
        # netlinxDoc[:structures] << t
      # when e.is_a?(VariableDefinition)
        # t = transform_variable_definition e
        # netlinxDoc[:variables] << t
      end
      
    end
    
    
    def transform_block_comment(e)
      
    end
    
    def transform_comment(e)
      
    end
    
    def transform_event_definition(e)
      
    end
    
    def transform_event_handler(e)
      
    end
    
    def transform_function_definition(e)
      
    end
    
    def transform_conditional(e)
      
    end
    
    def transform_program_name(e)
      nameElement = find e, StringLiteral
      (nameElement.nil?) ? '' : nameElement.text_value[1..-2]
    end
    
    def transform_include_directive(e)
      
    end
    
    def transform_device_definition(e)
      #binding.pry
    end
    
    def transform_device_combine(e)
      
    end
    
    def transform_constant_definition(e)
      
    end
    
    def transform_structure_definition(e)
      
    end
    
    def transform_assignment(e)
      
    end
    
  end
end
