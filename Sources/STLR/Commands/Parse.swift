import Foundation
import CommandKit
import OysterKit

class ParseCommand : Command, IndexableOptioned, IndexableParameterized, GrammarConsumer {
    typealias OptionIndexType = Options
    typealias ParameterIndexType = Parameters
    
    enum Parameters : Int, ParameterIndex {
        case inputFile

        var parameter: Parameter {
            switch self {
            case .inputFile: return StandardParameterType.fileUrl.multiple(optional: true)
            }
        }
        
        static var all: [Parameter] = [ inputFile.parameter ]
    }
    
    var inputFiles : [URL] {
        if let inputFile = parameters[0][0] as? URL {
            return [inputFile]
        }
        return []
    }
    
    var interactiveMode : Bool {
        return inputFiles.count == 0
    }
    
    enum Options : String, OptionIndex {
        case grammar
        var option : Option {
            switch self {
            case .grammar : return GrammarOption()
            }
        }
        static var all : [Option] { return [Options.grammar.option] }
    }
    
    init(){
        super.init("parse", description: "Parses a set of input files using the supplied grammar", options: Options.all, parameters: [])
    }
    
    override func run() -> RunnableReturnValue {
        guard let grammar = grammar else {
            print("Could not load grammar \(grammarUrl?.path ?? "file note specified")")
            return RunnableReturnValue.failure(error: GrammarOption.Errors.couldNotParseGrammar, code: -1)
        }

        if interactiveMode {
            
        } else {
            let input = String(contentsOfFile: inputFiles[0].path, encoding: String.Encoding.utf8)
            
            
        }
        
        return RunnableReturnValue.success
    }
}
