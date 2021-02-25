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

private var treeDepthPrint: Int = 0

/// Ugly code but works, this is only for testing purposes.
extension World {
    func printElementTree() {
        assert(rootElement != nil, "Root element must not be nil")
        print("\(generateTabs(number: treeDepthPrint)) -> \(type(of: element(for: rootElement!.elementID)!))")
        printElement(elementID: rootElement!.elementID)
        treeDepthPrint = 0
    }

    func printElement(elementID: ElementID) {
        treeDepthPrint += 1
        children(of: elementID)?.forEach({
            if let display = display(for: $0) {
                let tabs = generateTabs(number: treeDepthPrint)
                let elementType = type(of: element(for: $0)!)
                let displayType = type(of: display)
                var parentElementR: Element?
                if let parent = parent(of: $0), let parentElement = element(for: parent) {
                    parentElementR = parentElement
                }
                print("\(tabs) [\($0)] \(elementType) [\(displayType)] {\(parentElementR)}")
            } else {
                var parentElementR: Element?
                if let parent = parent(of: $0), let parentElement = element(for: parent) {
                    parentElementR = parentElement
                }
                if let e = element(for: $0) {
                    print("\(generateTabs(number: treeDepthPrint)) [\($0)] \(type(of: e)) {\(parentElementR)}")
                } else {
                    print("\(generateTabs(number: treeDepthPrint)) [\($0)] NIL {\(parentElementR)}")
                }
                
            }
            printElement(elementID: $0)
        })
        treeDepthPrint -= 1
    }

    func generateTabs(number: Int) -> String {
        var finalString = ""
        for _ in 0..<number {
            finalString += "\t"
        }
        return finalString
    }
    
    func printStats() {
        print("""
        [World]
            [+] Number of elements: \(elements.count)
            [+] Number of enviroment properties: \(enviromentStack.count)
        """)
    }
}
#endif
