//
//  File.swift
//  
//
//  Created by Angel Landoni on 16/2/21.
//

import Runtime

public enum MetadataKind: UInt {
  // Flags:
  // runtimePrivate = 0x100
  // nonHeap = 0x200
  // nonType = 0x400
  
  case `class` = 0
  case `struct` = 0x200     // 0 | nonHeap
  case `enum` = 0x201       // 1 | nonHeap
  case optional = 0x202     // 2 | nonHeap
  case foreignClass = 0x203 // 3 | nonHeap
  case opaque = 0x300       // 0 | runtimePrivate | nonHeap
  case tuple = 0x301        // 1 | runtimePrivate | nonHeap
  case function = 0x302     // 2 | runtimePrivate | nonHeap
  case existential = 0x303  // 3 | runtimePrivate | nonHeap
  case metatype = 0x304     // 4 | runtimePrivate | nonHeap
  case objcClassWrapper = 0x305     // 5 | runtimePrivate | nonHeap
  case existentialMetatype = 0x306  // 6 | runtimePrivate | nonHeap
  case heapLocalVariable = 0x400    // 0 | nonType
  case heapGenericLocalVariable = 0x500 // 0 | nonType | runtimePrivate
  case errorObject = 0x501  // 1 | nonType | runtimePrivate
  case unknown = 0xffff
  
  init(_ rawType: UInt) {
    if let result = MetadataKind(rawValue: rawType) {
      self = result
    } else {
      self = .unknown
    }
  }
}

extension Metadata {
    var kind: MetadataKind {
        MetadataKind(UInt(rawKind))
    }
}

extension Metadata: CustomStringConvertible {
    public var description: String {
        """
            [+] ValueWitnessTable: \(valueWitnessTable)
            [+] Kind: \(kind)
        """
    }
}
