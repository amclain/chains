require 'test_helper'
require "#{$lib}/chains/parser"

require "#{$lib}/chains/assignment"

class TestChainsParserIndentation < Test::Unit::TestCase
  
  def setup
    @parser = Chains::Parser.new
    
    # Push initial parent and indent.
    @parent = @parser.instance_eval {@parent}
    @parent << @parser.document
    
    @indent = @parser.instance_eval {@indent}
    @indent << 0
  end
  
  def teardown
    @parser = nil
  end
  
  # Wrapper
  def update_indent(line)
    @parser.send(:update_indent, line)
  end
  
  def test_no_change
    line1 = Chains::Assignment.new(@parent.first, 'myVar', '1')
    line2 = Chains::Assignment.new(@parent.first, 'myVar', '2')
    
    update_indent line1.to_s
    @parent << line1          # The parser would put elements back here. --------
    
    assert @parent.count == 2   # Document, line1
    assert @parent.last.value == '1'
    assert @indent.count == 1
    
    update_indent line2.to_s
    @parent << line2
    
    assert @parent.count == 2   # Document, line2
    assert @parent.last.value == '2'
    assert @indent.count == 1
    assert @indent.last == 0
  end
  
  def test_in_out_one_level
    # In one level.
    line1 = Chains::Verbatim.new(@parent.first, 'if x > 0')
    line2 = Chains::Verbatim.new(@parent.first, '  doStuff')
    
    update_indent line1.to_s
    @parent << line1
    
    update_indent line2.to_s
    @parent << line2
    
    assert @parent.count == 3   # Document, line1, line2.
    assert @parent.last == line2
    assert @parent[1] == line1
    
    assert @indent.count == 2   # 0, 2
    assert @indent.last == 2 # Last indent is 2 spaces over.
    
    
    # Stay on level.
    line3 = Chains::Verbatim.new(@parent.first, '  a = 1')
    update_indent line3.to_s
    @parent << line3
    
    assert @indent.count == 2 # 0, 2
    assert @indent.last == 2
    
    assert @parent.last == line3 
    assert @parent[@parent.index(line3) - 1] == line1 # Line3's parent should be line1.
    
    
    # Out one level.
    binding.pry
    line4 = Chains::Verbatim.new(@parent.first, 'x = 0')
    update_indent line4.to_s
    @parent << line4
    
    binding.pry
    assert @parent.count == 2
    assert @parent.last == line4
    
    assert @indent.count == 1
    assert @indent.last == 0
  end
  
end
