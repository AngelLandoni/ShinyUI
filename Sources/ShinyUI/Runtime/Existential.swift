//
//  File.swift
//  
//
//  Created by Angel Landoni on 16/2/21.
//

import Runtime

extension Existential {
    @_optimize(none)
    public static func fromProtocol<T>(_ value: T) -> Existential {
        return withUnsafePointer(to: value) { pointer in
            map_to_existential(pointer)
        }
    }
}


extension Existential: CustomStringConvertible {
    public var description: String {
        """
        [!] Existential:
            [+] ValueA: \(valueA)
            [+] ValueB: \(valueB)
            [+] ValueC: \(valueC)
            [+] Metadata: \n\t\(nest: commondMetadata.description)
            [*] Witness table: \(witnessTablesPtr)
        """
    }
}

extension Optional: CustomStringConvertible {
    public var description: String {
        if let data = self {
            return "\(data)"
        }
        return "NIL"
    }
}
