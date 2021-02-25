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

final class StorageElement: Element {
    // MARK: Element

    /// A which matches with the view contrapart.
    var elementID: ElementID

    // MARK: Lifecycle

    init(_ elementID: ElementID) {
        self.elementID = elementID
    }
}

extension Storage2: TreeElementBuilder {
    func buildElementTree<S: Storable>(_ storable: S) -> Element {
        ShinyUI.buildElementTree(self, storable)
    }
}

extension Storage3: TreeElementBuilder {
    func buildElementTree<S: Storable>(_ storable: S) -> Element {
        ShinyUI.buildElementTree(self, storable)
    }
}

extension Storage4: TreeElementBuilder {
    func buildElementTree<S: Storable>(_ storable: S) -> Element {
        ShinyUI.buildElementTree(self, storable)
    }
}

extension Storage5: TreeElementBuilder {
    func buildElementTree<S: Storable>(_ storable: S) -> Element {
        ShinyUI.buildElementTree(self, storable)
    }
}

extension Storage6: TreeElementBuilder {
    func buildElementTree<S: Storable>(_ storable: S) -> Element {
        ShinyUI.buildElementTree(self, storable)
    }
}

extension Storage7: TreeElementBuilder {
    func buildElementTree<S: Storable>(_ storable: S) -> Element {
        ShinyUI.buildElementTree(self, storable)
    }
}

extension Storage8: TreeElementBuilder {
    func buildElementTree<S: Storable>(_ storable: S) -> Element {
        ShinyUI.buildElementTree(self, storable)
    }
}

extension Storage9: TreeElementBuilder {
    func buildElementTree<S: Storable>(_ storable: S) -> Element {
        ShinyUI.buildElementTree(self, storable)
    }
}

extension Storage10: TreeElementBuilder {
    func buildElementTree<S: Storable>(_ storable: S) -> Element {
        ShinyUI.buildElementTree(self, storable)
    }
}
