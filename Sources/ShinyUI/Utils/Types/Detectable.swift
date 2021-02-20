//
//  Detectable.swift
//  
//
//  Created by Angel Landoni on 19/2/21.
//

public protocol Detectable {
    associatedtype ID: Hashable
    var id: ID { get }
}

extension Detectable where Self: AnyObject {
    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }
}
