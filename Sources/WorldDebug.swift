//  Copyright (c) 2021 Angel Landoni.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//     list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIEDi
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#if DEBUG

private var treeDeepPrint: Int = 0

/// Ugly code but works, this is only for testing purposes.
extension World {
    func printElementTree() {
        assert(rootElement != nil, "Root element must not be nil")
        print("\(generateTabs(number: treeDeepPrint)) -> \(type(of: elements[rootElement!]!))")
        printElement(elementID: rootElement!)
        treeDeepPrint = 0
    }

    func printElement(elementID: ElementID) {
        treeDeepPrint += 1
        children(of: elementID)?.forEach({
            if let display = displays[$0] {
                let tabs = generateTabs(number: treeDeepPrint)
                let elementType = type(of: elements[$0]!)
                let displayType = type(of: display)
                var parentElementR: Element?
                if let parent = childToParent[$0], let parentElement = elements[parent] {
                    parentElementR = parentElement
                }
                print("\(tabs) --> \(elementType) [\(displayType)] {\(parentElementR)}")
            } else {
                var parentElementR: Element?
                if let parent = childToParent[$0], let parentElement = elements[parent] {
                    parentElementR = parentElement
                }
                print("\(generateTabs(number: treeDeepPrint)) --> \(type(of: elements[$0]!)) {\(parentElementR)}")
            }
            printElement(elementID: $0)
        })
        treeDeepPrint -= 1
    }

    func generateTabs(number: Int) -> String {
        var finalString = ""
        for _ in 0..<number {
            finalString += "\t"
        }
        return finalString
    }
}
#endif
