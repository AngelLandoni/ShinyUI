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

enum ErrorMessages {
    static let elementDoesNotContainChild = "The element does not contain any children"

    static let stateUsedBeforeBodyCreation = "The State must be used only after body is created"
    static let bindingUsedBeforeBodyCreation = "The Binding must be used only after body is created"
    static let arrayDynamicPropertyShouldInvalidate = "Should invalidate should not be used on Arrays"
    static let arrayDynamicPropertyReadAccessFootPrint = "Read access footprint should not be used on Arrays"

    static let geometryReaderChildrenMismatch = "The GeometryReader must have only one child"

    static let anyViewNotAllowed = "AnyView not allowed"

    static let doesNotContainAnyChildren = "does not contain any children to layout"
    static let shouldHaveOnlyOneChild = "must only have 1 element as child"

    static let elementDoesNotHaveFrame = "The element does not have frame"

    static let elementNotFound = "The element for that elementID does not exist"

    static let childCannotBeDisplayed = "Child cannot be displayed"

    static let existErrorMarkAsInvalid = "Only existing elements can be mark as invalid."

    static let childCannotBeMeasured = "Child cannot be measured."
    
    static let emptyRootDisplayElement = "The root display element does not exit."
    
    static let emptyRoot = "The root element must not be nil."
}
