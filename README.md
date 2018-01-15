# stlr

A command line tool for performing operations on .stlr (STLR grammar files) such as generating Swift code or seeing the output of the parser. 

## Testing Parsers

    swift run stlr parse -g ./ExampleGrammars/Adventure.stlr
    
Will dynamically parse, using the supplied grammar, text entered into the command line creating a simple dump of the created AST (Abstract Syntax Tree). For example entering the following after the above command

    ATTACK KITTEN WITH CLUB
    
Would create

    command 'ATTACK KITTEN WITH CLUB'
        assault 'ATTACK'
        animal 'KITTEN'
        object 'CLUB'
  
## Generating Swift Parsers

    swift run stlr generate -g ./ExampleGrammars/Adventure.stlr -ot ~/Desktop/

Will generate the following code

    // 
    // STLR Generated Swift File
    // 
    // Generated: 2018-01-15 01:50:50 +0000
    // 
    import Cocoa
    import OysterKit

    // 
    // Adventure Parser
    // 
    enum Adventure : Int, Token {

        // Convenience alias
        private typealias T = Adventure

        case _transient = -1, `direction`, `object`, `animal`, `scenery`, `collectable`, `examineable`, `manipulate`, `locate`, `assault`, `look`, `move`, `inventory`, `attack`, `examine`, `command`

        func _rule(_ annotations: RuleAnnotations = [ : ])->Rule {
            switch self {
            case ._transient:
                return CharacterSet(charactersIn: "").terminal(token: T._transient)
            // direction
            case .direction:
                return ScannerRule.oneOf(token: T.direction, ["EAST", "WEST", "NORTH", "SOUTH"],[ : ].merge(with: annotations))
            // object
            case .object:
                return ScannerRule.oneOf(token: T.object, ["SWORD", "CLUB"],[ : ].merge(with: annotations))
            // animal
            case .animal:
                return ScannerRule.oneOf(token: T.animal, ["SNAKE", "KITTEN"],[ : ].merge(with: annotations))
            // scenery
            case .scenery:
                return ScannerRule.oneOf(token: T.scenery, ["STREAM", "TREE", "TAPESTRY"],[ : ].merge(with: annotations))
            // collectable
            case .collectable:
                return [
                        T.object._rule(),
                        T.animal._rule(),
                        ].oneOf(token: T.collectable, annotations: annotations)
            // examineable
            case .examineable:
                return [
                        T.object._rule(),
                        T.animal._rule(),
                        T.scenery._rule(),
                        ].oneOf(token: T.examineable, annotations: annotations)
            // manipulate
            case .manipulate:
                return ScannerRule.oneOf(token: T.manipulate, ["PICKUP", "DROP"],[ : ].merge(with: annotations))
            // locate
            case .locate:
                return ScannerRule.oneOf(token: T.locate, ["GO", "MOVE"],[ : ].merge(with: annotations))
            // assault
            case .assault:
                return ScannerRule.oneOf(token: T.assault, ["ATTACK", "KILL"],[ : ].merge(with: annotations))
            // look
            case .look:
                return ScannerRule.oneOf(token: T.look, ["LOOK AT", "EXAMINE"],[ : ].merge(with: annotations))
            // move
            case .move:
                return [
                        T.locate._rule(),
                        CharacterSet.whitespaces.terminal(token: T._transient),
                        T.direction._rule(),
                        ].sequence(token: T.move, annotations: annotations.isEmpty ? [ : ] : annotations)
            // inventory
            case .inventory:
                return [
                        T.manipulate._rule(),
                        CharacterSet.whitespaces.terminal(token: T._transient),
                        T.collectable._rule(),
                        ].sequence(token: T.inventory, annotations: annotations.isEmpty ? [ : ] : annotations)
            // attack
            case .attack:
                return [
                        T.assault._rule(),
                        CharacterSet.whitespaces.terminal(token: T._transient),
                        T.animal._rule(),
                        CharacterSet.whitespaces.terminal(token: T._transient),
                        "WITH".terminal(token: T._transient),
                        CharacterSet.whitespaces.terminal(token: T._transient),
                        T.object._rule(),
                        ].sequence(token: T.attack, annotations: annotations.isEmpty ? [ : ] : annotations)
            // examine
            case .examine:
                return [
                        T.look._rule(),
                        CharacterSet.whitespaces.terminal(token: T._transient),
                        T.examineable._rule(),
                        ].sequence(token: T.examine, annotations: annotations.isEmpty ? [ : ] : annotations)
            // command
            case .command:
                return [
                        T.move._rule(),
                        T.pickup._rule(),
                        T.drop._rule(),
                        T.attack._rule(),
                        T.examine._rule(),
                        ].oneOf(token: T.command, annotations: annotations)
            }
        }


        // Create a language that can be used for parsing etc
        public static var generatedLanguage : Parser {
            return Parser(grammar: [T.inventory._rule(), T.command._rule()])
        }

        // Convient way to apply your grammar to a string
        public static func parse(source: String) -> DefaultHeterogeneousAST {
            return Adventure.generatedLanguage.build(source: source)
        }
    }
