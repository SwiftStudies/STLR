//
//  StlrOptions.swift
//  OysterKitPackageDescription
//
//  Created by Swift Studies on 08/12/2017.
//

import Foundation
import CommandKit
import OysterKit

class LanguageOption : Option, IndexableParameterized {
    typealias ParameterIndexType    = Parameters
    
    /**
     Parameters
     */
    public enum Parameters : Int, ParameterIndex {
        case language = 0
        
        public var parameter: Parameter{
            switch self {
            case .language:
                return Language().one(optional: false)
            }
        }
        
        public static var all: [Parameter]{
            return [
                Parameters.language.parameter
            ]
        }
    }
    
    public struct Language : ParameterType{
        enum Supported : String{
            case swift
            case test

            var fileExtension : String {
                switch self {
                case .swift:
                    return rawValue
                case .test:
                    return "test"
                }
            }
            
            func generate(grammarName: String, from stlrParser:STLRParser, outputTo:String) throws {
                let generatedLanguage : String?
                
                switch self {
                case .swift:
                    generatedLanguage = stlrParser.ast.swift(grammar: grammarName)
                case .test:
                    generatedLanguage = "test"
                }
                
                if let generatedLanguage = generatedLanguage {
                    try generatedLanguage.write(toFile: outputTo, atomically: true, encoding: String.Encoding.utf8)
                } else {
                    print("Couldn't generate language".color(.red))
                }
            }
            
        }
        
        public var name = "Language"
        
        public func transform(_ argumentValue: String) -> Any? {
            return Supported(rawValue: argumentValue)
        }
    }
    
    init(){
        super.init(shortForm: "l", longForm: "language", description: "The language to generate", parameterDefinition: Parameters.all, required: false)
    }

}



