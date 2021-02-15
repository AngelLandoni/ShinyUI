//
//  File.swift
//  
//
//  Created by Angel Landoni on 12/2/21.
//

#if canImport(CoreGraphics)
import CoreGraphics

extension ElementFrame {
    var asFrame: CGRect {
        CGRect(x: position.x.cgFloat,
               y: position.y.cgFloat,
               width: size.width.cgFloat,
               height: size.height.cgFloat)
    }
}
#endif
