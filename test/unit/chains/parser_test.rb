require 'test_helper'
require "#{$lib}/chains/parser"

require "#{$lib}/chains/device_definition"

class TestChainsParser < Test::Unit::TestCase
  
  def setup
    @parser = Chains::Parser.new
  end
  
  def teardown
    @parser = nil
  end
  
  
  def test_assignment
    input = 
<<EOS
myVar   = 10
EOS
  
    doc = @parser.parse(input)
    
    assert doc.each_child.count  == 1
    
    doc.each_child do |child|
      assert child.symbol = 'myVar'
      assert child.value = '10'
    end
  end
  
  def test_device_definition
    input = 
<<EOS
vdvTP   = 33000:1:0
  dvTP  = 10001:1:0
 
dvTP2   = 10002:1:0
EOS
    
    doc = @parser.parse(input)
    
    count = doc.each_child(Chains::DeviceDefinition).count
    assert count == 2,
      "#{count} DeviceDefinition elements. Expected 2 (one is nested)."
    
    num = 0
    doc.each_child(Chains::DeviceDefinition) do |child|
      num += 1
      
      case num
      when 1
        # vdvTP
        assert child.symbol == 'vdvTP'
        assert child.value == '33000:1:0'
        
        assert child.each_child.count == 1
        
        nested = child.each_child.first
        assert nested.symbol == 'dvTP'
        assert nested.value == '10001:1:0'
      when 2
        assert child.symbol == 'dvTP2'
        assert child.value == '10002:1:0'
        
        assert child.each_child.count == 0
      end
    end
    
      
    input2 = 
<<EOS
vdvTP   = 33000:1:0
  dvTP  = 10001:1:0
 
  dvTP2   = 10002:1:0
EOS
    
    doc = @parser.parse(input2)
    
    count = doc.each_child(Chains::DeviceDefinition).count
    assert count == 1,
      "#{count} DeviceDefinition elements. Expected 1 (two are nested)."
    
    doc.each_child(Chains::DeviceDefinition) do |child|
      # vdvTP
      assert child.symbol == 'vdvTP'
      assert child.value == '33000:1:0'
      
      assert child.each_child.count == 2
      
      num = 0
      child.each_child do |nested|
        num += 1
        
        assert nested.each_child.count == 0
        
        case num
        when 1
          assert nested.symbol == 'dvTP'
          assert nested.value == '10001:1:0'
        when 2
          assert nested.symbol == 'dvTP2'
          assert nested.value == '10002:1:0'
        end
      end
    end
  end
  
  # def test_rollover_concatenation
    # input =
# <<EOS
# myVar2 =
  # 456
# EOS
# 
    # doc = @parser.parse(input)
#     
    # assert doc.each_child.count == 1
    # doc.each_child do |child|
      # assert child.symbol == 'myVar2'
      # assert child.value == '456'
    # end
  # end
  
  def test_indent_count
    # Nothing indented.
    r = @parser.send(:indent_count, "test")
    assert r == 0
    
    # Tab is the character to count.
    r = @parser.send(:indent_count, "\t\ttest")
    assert r == 2
    
    # Count tabs, ignore the space.
    r = @parser.send(:indent_count, "\t test")
    assert r == 1
    
    # Space is the character to count.
    r = @parser.send(:indent_count, "    test")
    assert r == 4
    
    # Count spaces, ignore tab.
    r = @parser.send(:indent_count, "   \ttest")
    assert r == 3
  end
  
  # def test_block_comment
    # flunk
  # end
#   
  # def test_single_line_comment
    # flunk
  # end
#   
  # def test_single_element
    # flunk
  # end
#   
  # def test_nested_element
    # flunk
  # end
#   
  # def test_syntax_error
    # flunk
  # end
  
end
