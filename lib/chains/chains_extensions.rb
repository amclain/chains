module Chains

	class Document < Treetop::Runtime::SyntaxNode
	end

	class DocumentElement < Treetop::Runtime::SyntaxNode
	end

  module BlockComment
  	class BlockComment < Treetop::Runtime::SyntaxNode
  	end
  end

	class Comment < Treetop::Runtime::SyntaxNode
	end

	class EventDefinition < Treetop::Runtime::SyntaxNode
	end

	class FunctionDefinition < Treetop::Runtime::SyntaxNode
	end

	class ProgramName < Treetop::Runtime::SyntaxNode
	end

	class IncludeDirective < Treetop::Runtime::SyntaxNode
	end

	class DeviceDefinition < Treetop::Runtime::SyntaxNode
	end

	class DPS < Treetop::Runtime::SyntaxNode
	end

	class DPSSegment < Treetop::Runtime::SyntaxNode
	end

	class ConstantDefinition < Treetop::Runtime::SyntaxNode
	end

	class Constant < Treetop::Runtime::SyntaxNode
	end

	class StructureDefinition < Treetop::Runtime::SyntaxNode
	end

	class VariableDefinition < Treetop::Runtime::SyntaxNode
	end
	
	class Assignment < Treetop::Runtime::SyntaxNode
  end

	class UserSymbol < Treetop::Runtime::SyntaxNode
	end

	class StringLiteral < Treetop::Runtime::SyntaxNode
	end

	class IntegerLiteral < Treetop::Runtime::SyntaxNode
	end

	class FloatLiteral < Treetop::Runtime::SyntaxNode
	end

	class Indent < Treetop::Runtime::SyntaxNode
	end

	class Outdent < Treetop::Runtime::SyntaxNode
	end
  
  module VariableType
    class VariableType < Treetop::Runtime::SyntaxNode
    end
  end
  
end

