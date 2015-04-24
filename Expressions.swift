﻿import Sugar
import Sugar.Collections
import Sugar.Linq

/* Expressions */

public __abstract class CGExpression: CGStatement {
}

public class CGRawExpression : CGExpression { // not language-agnostic. obviosuly.
	public var Lines: List<String>

	public init(_ lines: List<String>) {
		Lines = lines
	}
	public init(_ lines: String) {
		Lines = lines.Replace("\r", "").Split("\n").ToList()
	}
}

public class CGTypeReferenceExpression : CGExpression{
	public var `Type`: CGTypeReference

	public init(_ type: CGTypeReference) {
		`Type` = type
	}
}

public class CGAssignedExpression: CGExpression {
	public var Value: CGExpression
	public var Inverted: Boolean = false
	
	public init(_ value: CGExpression) {
		Value = value
	}
}

public class CGSizeOfExpression: CGExpression {
	public var Expression: CGExpression

	public init(_ expression: CGExpression) {
		Expression = expression
	}
}

public class CGTypeOfExpression: CGExpression {
	public var Expression: CGExpression

	public init(_ expression: CGExpression) {
		Expression = expression
	}
}

public class CGDefaultExpression: CGExpression {
	public var `Type`: CGTypeReference

	public init(_ type: CGTypeReference) {
		`Type` = type
	}
}

public class CGSelectorExpression: CGExpression { /* Cocoa only */
	var Name: String
	
	public init(_ name: String) {
		Name = name;
	}
}

public class CGTypeCastExpression: CGExpression {
	public var Expression: CGExpression
	public var TargetType: CGTypeReference
	public var ThrowsException = false
	public var GuaranteedSafe = false // in Silver, this uses "as"

	public init(_ expression: CGExpression, _ targetType: CGTypeReference) {
		Expression = expression
		TargetType = targetType
	}
}

public class CGAwaitExpression: CGExpression {
	//incomplete
}

public class CGAnonymousMethodExpression: CGExpression {
	public var Lambda = true

	public var Parameters: List<CGParameterDefinition>
	public var ReturnType: CGTypeReference?
	public var Statements: List<CGStatement>
	public var LocalVariables: List<CGVariableDeclarationStatement>? // Legacy Delphi only.

	public init(_ statements: List<CGStatement>) {
		super.init()
		Parameters = List<CGParameterDefinition>()
		Statements = statements;
	}
	public init(_ parameters: List<CGParameterDefinition>, _ statements: CGStatement...) {
		super.init()
		Statements = statements.ToList()
		Parameters = parameters;
	}
}

public enum CGAnonymousTypeKind {
	case Class
	case Struct
	case Interface
}

public class CGAnonymousTypeExpression: CGExpression {
	public var Kind: CGAnonymousTypeKind
	public var Members = List<CGMemberDefinition>()
	
	public init(_ kind: CGAnonymousTypeKind) {
		Kind = kind
	}
}

public class CGInheritedExpression: CGExpression {
	public static lazy let Inherited = CGInheritedExpression()
}

public class CGIfThenElseExpression: CGExpression { // aka Ternary operator
	public var Condition: CGExpression
	public var IfExpression: CGExpression
	public var ElseExpression: CGExpression?
	
	public init(_ condition: CGExpression, _ ifExpression: CGExpression, _ elseExpression: CGExpression?) {
		Condition = condition
		IfExpression= ifExpression
		ElseExpression = elseExpression
	}	
}

/*
public class CGSwitchExpression: CGExpression { //* Oxygene only */
	//incomplete
}

public class CGSwitchExpressionCase : CGEntity {
	public var CaseExpression: CGExpression
	public var ResultExpression: CGExpression

	public init(_ caseExpression: CGExpression, _ resultExpression: CGExpression) {
		CaseExpression = caseExpression
		ResultExpression = resultExpression
	}
}

public class CGForToLoopExpression: CGExpression { //* Oxygene only */
	//incomplete
}

public class CGForEachLoopExpression: CGExpression { //* Oxygene only */
	//incomplete
}
*/

public class CGPointerDereferenceExpression: CGExpression {
	public var PointerExpression: CGExpression

	public init(_ pointerExpression: CGExpression) {
		PointerExpression = pointerExpression
	}   
}

public class CGParenthesesExpression: CGExpression {
	var Value: CGExpression

	public init(_ value: CGExpression) {
		Value = value
	}
}

public class CGUnaryOperatorExpression: CGExpression {
	var Value: CGExpression
	var Operator: CGUnaryOperatorKind? // for standard operators
	var OperatorString: String? // for custom operators

	public init(_ value: CGExpression, _ `operator`: CGUnaryOperatorKind) {
		Value = value
		Operator = `operator`
	}
	public init(_ value: CGExpression, _ operatorString: String) {
		Value = value
		OperatorString = operatorString
	}
	
	public static func NotExpression(value: CGExpression) -> CGUnaryOperatorExpression {
		return CGUnaryOperatorExpression(value, CGUnaryOperatorKind.Not)
	}
}

public enum CGUnaryOperatorKind {
	case Plus
	case Minus
	case Not
	case AddressOf
}

public class CGBinaryOperatorExpression: CGExpression {
	var LefthandValue: CGExpression
	var RighthandValue: CGExpression
	var Operator: CGBinaryOperatorKind? // for standard operators
	var OperatorString: String? // for custom operators
	
	public init(_ lefthandValue: CGExpression, _ righthandValue: CGExpression, _ `operator`: CGBinaryOperatorKind) {
		LefthandValue = lefthandValue
		RighthandValue = righthandValue
		Operator = `operator`;
	}
	public init(_ lefthandValue: CGExpression, _ righthandValue: CGExpression, _ operatorString: String) {
		LefthandValue = lefthandValue
		RighthandValue = righthandValue
		OperatorString = operatorString;
	}
}

public enum CGBinaryOperatorKind {
	case Addition
	case Subtraction
	case Multiplication
	case Division
	case LegacyPascalDivision // "div"
	case Modulus
	case Equals
	case NotEquals
	case LessThan
	case LessThanOrEquals
	case GreaterThan
	case GreatThanOrEqual
	case LogicalAnd
	case LogicalOr
	case LogicalXor
	case Shl
	case Shr
	case BitwiseAnd
	case BitwiseOr
	case BitwiseXor
	case Implies /* Oxygene only */
	case Is
	case IsNot
	case In /* Oxygene only */
	case NotIn
	/*case Assign
	case AssignAddition
	case AssignSubtraction
	case AssignMultiplication
	case AssignDivision
	case AssignModulus
	case AssignBitwiseAnd
	case AssignBitwiseOr
	case AssignBitwiseXor
	case AssignShl
	case AssignShr*/
}


/* Literal Expressions */

public class CGNamedIdentifierExpression: CGExpression { 
	public var Name: String
	
	public init(_ name: String) {
		Name = name;
	}
}

public class CGSelfExpression: CGExpression { // "self" or "this"
	public static lazy let `Self` = CGSelfExpression()
}

public class CGNilExpression: CGExpression { // "nil" or "null"
	public static lazy let Nil = CGNilExpression()
}

public class CGPropertyValueExpression: CGExpression { /* "value" or "newValue" in C#/Swift */
	public static lazy let PropertyValue = CGPropertyValueExpression()
}

public class CGLiteralExpression: CGExpression {
}

public class CGLanguageAgnosticLiteralExpression: CGExpression {
	internal var StringRepresentation: String {
		assert(false, "StringRepresentation not implemented")
		return "###";
	}
}

public class CGStringLiteralExpression: CGLiteralExpression {
	public var Value: String = ""
	
	public static lazy let Empty: CGStringLiteralExpression = "".AsLiteralExpression()
	public static lazy let Space: CGStringLiteralExpression = " ".AsLiteralExpression()

	public init() {
	}
	public init(_ value: String) {
		Value = value
	}	
}

public class CGCharacterLiteralExpression: CGLiteralExpression {
	public var Value: Char = "\0"

	//public static lazy let Zero: CGCharacterLiteralExpression = "\0".AsLiteralExpression()
	public static lazy let Zero = CGCharacterLiteralExpression("\0")

	public init() {
	}
	public init(_ value: Char) {
		Value = value
	}	
}

public class CGIntegerLiteralExpression: CGLanguageAgnosticLiteralExpression {
	public var Value: Int64 = 0

	public static lazy let Zero: CGIntegerLiteralExpression = 0.AsLiteralExpression()

	public init() {
	}
	public init(_ value: Int64) {
		Value = value
	}

	override var StringRepresentation: String {
		return Value.ToString() 
	}
}

public class CGFloatLiteralExpression: CGLanguageAgnosticLiteralExpression {
	public var Value: Double = 0
	
	public static lazy let Zero: CGFloatLiteralExpression = 0.0.AsLiteralExpression()
	
	public init() {
	}
	public init(_ value: Double) {
		Value = value
	}

	override var StringRepresentation: String {
		return Value.ToString() // todo: force dot into float literal?
	}
}

public class CGBooleanLiteralExpression: CGLanguageAgnosticLiteralExpression {
	public let Value: Boolean = false
	
	public static lazy let True = CGBooleanLiteralExpression(true)
	public static lazy let False = CGBooleanLiteralExpression(false)
	
	public init() {
	}
	public init(_ bool: Boolean) {
		Value = bool
	}

	override var StringRepresentation: String {
		if Value {
			return "true"
		} else {
			return "false"
		}
	}
}

public class CGArrayLiteralExpression: CGExpression {
	public var Elements: List<CGExpression> 
	public var ArrayKind: CGArrayKind = .Dynamic
	
	public init() {
		Elements = List<CGExpression>()
	}
	public init(_ elements: List<CGExpression>) {
		Elements = elements
	}
}

public class CGDictionaryLiteralExpression: CGExpression { /* Swift only, currently */
	public var Keys: List<CGExpression> 
	public var Values: List<CGExpression> 
	
	public init() {
		Keys = List<CGExpression>()
		Values = List<CGExpression>()
	}
	public init(_ keys: List<CGExpression>, _ values: List<CGExpression>) {
		Keys = keys
		Values = values
	}
}

public class CGTupleLiteralExpression : CGExpression {
	public var Members: List<CGExpression>
	
	public init(_ members: List<CGExpression>) {
		Members = members
	}
	public convenience init(_ members: CGExpression...) {
		init(members.ToList())
	}
}

/* Calls */

public class CGNewInstanceExpression : CGExpression {
	public var `Type`: CGTypeReference
	public var ConstructorName: String? // can optionally be provided for languages that support named .ctors (Elements, Objectice-C, Swift)
	public var Parameters: List<CGCallParameter>
	public var ArrayBounds: List<CGExpression>? // for array initialization.
	public var PropertyInitializers = List<CGCallParameter>() // for Oxygene extended .ctor calls

	public init(_ type: CGTypeReference) {
		`Type` = type
		Parameters = List<CGCallParameter>()
	}
	public init(_ type: CGTypeReference, _ parameters: List<CGCallParameter>?) {
		`Type` = type
		if let parameters = parameters {
			Parameters = parameters
		} else {
			Parameters = List<CGCallParameter>()
		}
	}
}

public class CGLocalVariableAccessExpression : CGExpression {
	public var Name: String
	public var NilSafe: Boolean = false // true to use colon or elvis operator
	public var UnwrapNullable: Boolean = false // Swift only

	public init(_ name: String) {
		Name = name
	}
}

public __abstract class CGMemberAccessExpression : CGExpression {
	public var CallSite: CGExpression? // can be nil to call a local or global function/variable. Should be set to CGSelfExpression for local methods.
	public var Name: String
	public var NilSafe: Boolean = false // true to use colon or elvis operator
	public var UnwrapNullable: Boolean = false // Swift only

	public init(_ callSite: CGExpression?, _ name: String) {
		CallSite = callSite
		Name = name
	}
}

public class CGFieldAccessExpression : CGMemberAccessExpression {
}

public class CGEnumValueAccessExpression : CGExpression {
	public var `Type`: CGTypeReference
	public var ValueName: String

	public init(_ type: CGTypeReference, _ valueName: String) {
		`Type` = type
		ValueName = valueName
	}
}

public class CGMethodCallExpression : CGMemberAccessExpression{
	public var Parameters: List<CGCallParameter>
	public var CallOptionally: Boolean = false // Swift only

	public init(_ callSite: CGExpression?, _ name: String) {
		super.init(callSite, name)
		Parameters = List<CGCallParameter>()
	}
	public init(_ callSite: CGExpression?, _ name: String, _ parameters: List<CGCallParameter>?) {
		super.init(callSite, name)
		if let parameters = parameters {
			Parameters = parameters
		} else {
			Parameters = List<CGCallParameter>()
		}   
	}
}

public class CGPropertyAccessExpression: CGMemberAccessExpression {
	public var Parameters: List<CGCallParameter>

	public init(_ callSite: CGExpression?, _ name: String, _ parameters: List<CGCallParameter>?) {
		super.init(callSite, name)
		if let parameters = parameters {
			Parameters = parameters
		} else {
			Parameters = List<CGCallParameter>()
		}   
	}
}

public class CGCallParameter: CGEntity {
	public var Name: String? // optional, for named parameters or prooperty initialziers
	public var Value: CGExpression
	public var Modifier: ParameterModifierKind = .In
	
	public init(_ value: CGExpression) {
		Value = value
	}
	public init(_ value: CGExpression, _ name: String) {
		//public init(value) // 71582: Silver: delegating to a second .ctor doesn't properly detect that a field will be initialized
		Value = value
		Name = name
	}
}

public class CGArrayElementAccessExpression: CGExpression {
	public var Array: CGExpression
	public var Parameters: List<CGExpression>

	public init(_ array: CGExpression, _ parameters: List<CGExpression>) {
		Array = array
		Parameters = parameters
	}
}
