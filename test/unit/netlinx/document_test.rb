require 'test_helper'
require "#{$lib}/netlinx/document"

class TestDevice < Test::Unit::TestCase
  
  def test_get_document_section
    doc = NetLinx::Document.new
    
    section = doc[:events]
    assert_not_nil section,
      'Section should not be nil.'
    assert section.is_a?(NetLinx::Section),
      'Should have returned type Section.'
  end
  
end
