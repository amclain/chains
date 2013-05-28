require 'test_helper'
require "#{$lib}/chains/parser"

require "#{$lib}/chains/assignment"

class TestChainsParserIndentation < Test::Unit::TestCase
  
  def setup
    @parser = Chains::Parser.new
    
    # Push initial parent and indent.
    @parent = @parser.instance_eval {@parent}
    @parent << @parser.document
    
    @sibling = @parser.instance_eval{@sibling}
    
    @indent = @parser.instance_eval {@indent}
    @indent << 0
    
    @lines = Array.new
  end
  
  def teardown
    @parser = nil
    @parent = nil
    @sibling = nil
    @indent = nil
    
    @lines.clear
  end
  
  # Wrapper
  def update_indent(line)
    @parser.send(:update_indent, line)
  end
  
  # Helper
  def make_line_no_push(text)
    @lines << Chains::Verbatim.new(@parent.first, text)
    update_indent @lines.last.to_s
  end
  
  # Helper
  def make_line(text)
    make_line_no_push text
    @parent << @lines.last
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
    assert @parent[-2] == line1 # Line3's parent should be line1.
    
    
    # Out one level.
    line4 = Chains::Verbatim.new(@parent.first, 'x = 0')
    update_indent line4.to_s
    @parent << line4
    
    assert @parent.count == 2
    assert @parent.last == line4
    
    assert @indent.count == 1
    assert @indent.last == 0
  end
  
  
  def test_in_out_multiple_levels
    @lines.clear
    
    # In one level.
    make_line 'myFunction ->'
    make_line '  ui items[5]'
    
    # Stay 2 spaces in.
    make_line '  for i in items'
    assert @parent.count == 3  # Document, function, for
    assert @indent.count == 2
    
    # In another level, 4 spaces.
    make_line '    if i > 0'
    assert @parent.count == 4
    assert @indent.count == 3
    assert @indent.last == 4
    
    # In another level at a strange but acceptable number of spaces, 8.
    # Spacing shouldn't matter on a new indent as long as it's more
    # than the last indent.
    make_line '        doStuff i'
    assert @parent.count == 5 # Doc, function, for, if, doStuff
    assert @indent.count == 4 # 0, 2, 4, 8
    assert @indent.last == 8
    
    # Same level, 8 spaces.
    make_line '        if i == 2'
    ifI2 = @lines.last
    
    # Indent again, 10 spaces.
    make_line '          updateTouchPanel'
    assert @parent.count == 6 # Doc, function, for, if, if, update
    
    # Outdent to 4 spaces.
    # Should clear out 2 parents: 'update...' and 'if i == 2'
    make_line '    else if i == 4'
    # Make 'else' a sibling of 'if'.
    ifI2 ^ @lines.last
    
    assert @parent.count == 5, # Doc, function, for, if, else_if
      "Count: #{@parent.count}"
    assert @indent.count == 3
    assert @indent.last == 4
    assert @parent[-2] == ifI2 # 'if i == 2' should still be on the stack.
    
    
    # Indent to 6 spaces.
    make_line '      if x == 0'
    ifX0 = @lines.last
    assert @parent.count == 6 # Doc, function, for, if, else_if, if
    
    # Indent to 8 spaces.
    make_line '        selfDestruct'
    assert @parent.count == 7 # Doc, function, for, if, else_if, if, statement
    
    # Outdent to 6 spaces.
    make_line '      else'
    ifX0 ^ @lines.last # Make sibling.
    assert @parent.count == 7 # Doc, function, for, if, else_if, if, else
    assert @parent[-2] == ifX0 # 'if x == 0' should still be on the stack.
    
    # Indent to 8 spaces.
    make_line '        doOtherStuff i'
    assert @parent.count == 7 # Doc, function, for, if, else_if, if, statement
    
    # Outdent to 4 spaces.
    make_line '    else'
    assert @parent.count == 5, # Doc, function, for, if, else
      "Parent Count: #{@parent.count}"
    assert @parent[-2] == ifI2 # 'if i == 2' should still be on the stack.
    
    ## TODO: Test indent
    
    # Indent to 6 spaces.
    make_line '      doNothing'
    assert @parent.count == 6 # Doc, function, for, if, else, statement
    
    # Outdent to 2 spaces, function body.
    make_line '  x = i'
    assert @parent.count == 3 # Doc, function, assignment
    assert @indent.count == 2 # 0, 2
    assert @indent.last == 2
    
    # Outdent back to 0.
    make_line 'func2 ->'
    assert @parent.count == 2 # Doc, function
    assert @indent.count == 1 # 0
    assert @indent.last == 0
  end
  
end
