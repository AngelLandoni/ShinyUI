//
//  StringInterpolation.swift
//  
//
//  Created by Angel Landoni on 16/2/21.
//

// https://forums.swift.org/t/multi-line-string-nested-indentation-with-interpolation/36933/2
extension DefaultStringInterpolation {
    mutating func appendInterpolation(nest value: String) {
        let indent = String(stringInterpolation: self).reversed().prefix { " \t".contains($0) }
        if indent.isEmpty {
             appendInterpolation(value)
         } else {
             appendLiteral(
                value.split(
                    separator: "\n",
                    omittingEmptySubsequences: false).joined(
                        separator: "\n" + indent))
         }
    }
}
