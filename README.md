# stlr

A command line tool for performing operations on .stlr (STLR grammar files) such as generating Swift code or seeing the output of the parser. 

## Testing Parsers

    swift run stlr parse -g ./ExampleGrammars/Adventure.stlr
    
Will dynamically parse, using the supplied grammar, text entered into the command line creating a simple dump of the created AST (Abstract Syntax Tree). For example entering the following after the above command

    ATTACK KITTEN WITH CLUB
    
Would create

    command 'ATTACK KITTEN WITH CLUB'
      attack 'ATTACK KITTEN WITH CLUB'
        animal 'KITTEN'
        object 'CLUB'
  
## Generating Swift Parsers

    swift run stlr generate -g ./ExampleGrammars/Adventure.stlr -ot ~/Desktop/

Will generate the following code

    // 
    // STLR Generated Swift File
    // 
    // Generated: 2018-01-14 23:19:06 +0000
    // 
    import OysterKit

    // 
    // Adventure Parser
    // 
    enum Adventure : Int, Token {

      // Convenience alias
      private typealias T = Adventure

      case _transient = -1, `direction`, `object`, `animal`, `scenery`, `collectable`, `examineable`, `move`, `pickup`, `drop`, `attack`, `examine`, `command`

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
              ].oneOf(token: T.collectable)
        // examineable
        case .examineable:
          return [
              T.object._rule(),
              T.animal._rule(),
              T.scenery._rule(),
              ].oneOf(token: T.examineable)
        // move
        case .move:
          return [
              "GO".terminal(token: T._transient),
              CharacterSet.whitespaces.terminal(token: T._transient),
              T.direction._rule(),
              ].sequence(token: T.move, annotations: annotations.isEmpty ? [ : ] : annotations)
        // pickup
        case .pickup:
          return [
              "PICKUP".terminal(token: T._transient),
              CharacterSet.whitespaces.terminal(token: T._transient),
              T.collectable._rule(),
              ].sequence(token: T.pickup, annotations: annotations.isEmpty ? [ : ] : annotations)
        // drop
        case .drop:
          return [
              "DROP".terminal(token: T._transient),
              CharacterSet.whitespaces.terminal(token: T._transient),
              T.collectable._rule(),
              ].sequence(token: T.drop, annotations: annotations.isEmpty ? [ : ] : annotations)
        // attack
        case .attack:
          return [
              "ATTACK".terminal(token: T._transient),
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
              "EXAMINE".terminal(token: T._transient),
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
              ].oneOf(token: T.command)
        }
      }


      // Create a language that can be used for parsing etc
      public static var generatedLanguage : Parser {
        return Parser(grammar: [T.command._rule()])
      }

      // Convient way to apply your grammar to a string
      public static func parse(source: String) -> DefaultHeterogeneousAST {
        return Adventure.generatedLanguage.build(source: source)
      }
    }

