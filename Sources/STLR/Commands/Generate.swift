import CommandKit
import OysterKit


class GenerateCommand : Command, IndexableOptioned, GrammarConsumer, OutputLocationConsumer {
    typealias OptionIndexType       = Options
    
    /**
     How options are indexed
     */
    public enum Options : String, OptionIndex {
        case language , outputTo = "output-to", grammar
        
        var option : Option {
            switch self {
            case .grammar:  return GrammarOption()
            case .language: return LanguageOption()
            case .outputTo: return OutputFileOption()
            }
        }
        
        static var all : [Option] {
            return [
                language.option,
                outputTo.option,
                grammar.option,
            ]
        }
    }
    
    public enum GenerationError : Error {
        case missingGrammarFile
        case outputLocationNotSpecified
        case couldNotParseGrammar
    }
    
    init(){
        super.init("generate", description: "Creates source code in the specified format for the supplied grammar", options: Options.all, parameters: [])
    }
    
    
    var language : LanguageOption.Language.Supported {
        return self[Options.language, LanguageOption.Parameters.language,0] ?? .swift
    }
    
    override func run() -> RunnableReturnValue {
        guard let grammarName = grammarName else {
            return RunnableReturnValue.failure(error: GenerationError.missingGrammarFile, code: 0)
        }
        
        guard let outputLocation = outputLocation else {
            return RunnableReturnValue.failure(error: GenerationError.outputLocationNotSpecified, code: 0)
        }
        
        guard let grammar = grammar else {
            return RunnableReturnValue.failure(error: GenerationError.couldNotParseGrammar, code: 0)
        }
        
        print("Generating \(grammarName.style(.italic)) as \(language)")
        
        do {
            try language.generate(grammarName: grammarName, from: grammar, outputTo: outputLocation.url(defaultName: "\(grammarName).\(language.fileExtension)").path.canonicalPath)
            
        } catch {
            return RunnableReturnValue.failure(error: error, code: -1)
        }
        
        return RunnableReturnValue.success
    }
}
