require 'test_helper'
require "#{$lib}/chains/parser"

require "#{$lib}/chains/assignment"

class TestChainsParserIndentation < Test::Unit::TestCase
  
  def setup
    @parser = Chains::Parser.new
    
    @indent = @parser.instance_eval {@indent}
    @indent << 0
    
    @lines = Array.new
  end
  
  def teardown
    @parser = nil
    @indent = nil
    
    @lines.clear
  end
  
  # Wrapper
  def update_indent(line)
    @parser.send(:update_indent, line)
  end
  
  # Helper
  def make_line(text)
    @lines << Chains::Verbatim.new(nil, text)
    update_indent @lines.last.to_s
  end
  
  
  def test_no_change
    line1 = Chains::Assignment.new(nil, 'myVar', '1')
    line2 = Chains::Assignment.new(nil, 'myVar', '2')
    
    update_indent line1.to_s
    assert @indent.count == 1
    
    update_indent line2.to_s
    assert @indent.count == 1
    assert @indent.last == 0
  end
  
  
  def test_in_out_one_level
    # In one level.
    line1 = Chains::Verbatim.new(nil, 'if x > 0')
    line2 = Chains::Verbatim.new(nil, '  doStuff')
    
    update_indent line1.to_s
    
    update_indent line2.to_s
    assert @indent.count == 2   # 0, 2
    assert @indent.last == 2 # Last indent is 2 spaces over.
    
    
    # Stay on level.
    line3 = Chains::Verbatim.new(nil, '  a = 1')
    update_indent line3.to_s
    assert @indent.count == 2 # 0, 2
    assert @indent.last == 2
    
    # Out one level.
    line4 = Chains::Verbatim.new(nil, 'x = 0')
    update_indent line4.to_s
    
    assert @indent.count == 1
    assert @indent.last == 0
  end
  
  
  def test_in_out_multiple_levels
    @lines.clear
    
    # In one level.
    make_line 'myFunction ->'
    i = make_line '  ui items[5]'
    assert i == 1
    
    # Stay 2 spaces in.
    i = make_line '  for i in items'
    assert i == 0
    assert @indent.count == 2
    
    # In another level, 4 spaces.
    i = make_line '    if i > 0'
    assert i == 1
    assert @indent.count == 3
    assert @indent.last == 4
    
    # In another level at a strange but acceptable number of spaces, 8.
    # Spacing shouldn't matter on a new indent as long as it's more
    # than the last indent.
    i = make_line '        doStuff i'
    assert i == 1
    assert @indent.count == 4 # 0, 2, 4, 8
    assert @indent.last == 8
    
    # Same level, 8 spaces.
    i = make_line '        if i == 2'
    assert i == 0
    
    # Indent again, 10 spaces.
    i = make_line '          updateTouchPanel'
    assert i == 1
    
    # Outdent to 4 spaces.
    # Should clear out 2 parents: 'update...' and 'if i == 2'
    i = make_line '    else if i == 4'
    assert i == -2
    
    assert @indent.count == 3
    assert @indent.last == 4
    
    # Indent to 6 spaces.
    i = make_line '      if x == 0'
    assert i == 1
    
    # Indent to 8 spaces.
    i = make_line '        selfDestruct'
    assert i == 1
    
    # Outdent to 6 spaces.
    i = make_line '      else'
    assert i == -1
    
    # Indent to 8 spaces.
    i = make_line '        doOtherStuff i'
    assert i == 1
    
    # Outdent to 4 spaces.
    i = make_line '    else'
    assert i == -2
    
    # Indent to 6 spaces.
    i = make_line '      doNothing'
    assert i == 1
    
    # Outdent to 2 spaces, function body.
    i = make_line '  x = i'
    assert i == -2
    assert @indent.count == 2 # 0, 2
    assert @indent.last == 2
    
    # Outdent back to 0.
    i = make_line 'func2 ->'
    assert i == -1
    assert @indent.count == 1 # 0
    assert @indent.last == 0
  end
  
end
