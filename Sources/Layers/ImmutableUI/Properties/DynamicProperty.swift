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

protocol DynamicProperty {
    var owner: Ref<OwnerEntry?> { get set }
    func configureInvalidationAfterElementCreation()
    func resetInvalidationState()
    func bodyStartReading()
    func bodyStopReading()
}

extension DynamicProperty {
    func configureInvalidationAfterElementCreation() { }
    func resetInvalidationState() { }
    func bodyStartReading() { }
    func bodyStopReading() { }
}

extension Array: DynamicProperty where Element == DynamicProperty {
    var bodyReadAccessFootprint: Ref<Bool> {
        get {
            fatalError(ErrorMessages.arrayDynamicPropertyReadAccessFootPrint)
        }
        set {
            fatalError(ErrorMessages.arrayDynamicPropertyReadAccessFootPrint)
        }
    }

    var shouldInvalidate: Ref<Bool> {
        get { fatalError(ErrorMessages.arrayDynamicPropertyShouldInvalidate) }
        set { fatalError(ErrorMessages.arrayDynamicPropertyShouldInvalidate) }
    }

    var owner: Ref<OwnerEntry?> {
        get {
            // All the owners inside this array should point to the same one.
            // A state can only have one owner and all the states in a node
            // belongs to the same node.
            first?.owner ?? Ref(nil)
        }
        mutating set {
            // TODO: Not sure if this is working, if something is working wrong
            // check here.
            for var element in self {
                element.owner = newValue
            }
        }
    }

    func configureInvalidationAfterElementCreation() {
        for property in self {
            property.configureInvalidationAfterElementCreation()
        }
    }

    func resetInvalidationState() {
        for property in self {
            property.resetInvalidationState()
        }
    }

    func bodyStartReading() {
        for property in self {
            property.bodyStartReading()
        }
    }

    func bodyStopReading() {
        for property in self {
            property.bodyStopReading()
        }
    }
}

// MARK: - Utils

/// Returns all the states within a specific view.
///
/// - TODO: Avoid mirror use directly the metadata.
func dynamicPropertyDumper<V: View>(view: V) -> [DynamicProperty] {
    Mirror(reflecting: view).children.compactMap {
        guard let property = $0.value as? DynamicProperty else { return nil }
        return property
    }
}

/// Resets the read state of the `DynamicProperty`.
///
/// If the view is regenerated it must be reseted in order not forgot the previous state read flags. This can
/// happen if the `View`'s body is branched (e.g `If`, etc) and some of the states inside it is not read
/// any more, in this case the `State` that is not read any more should be mark as a no invalidator
/// candidate to avoid unnecessary `body` rebuilds.
///
/// - Parameter view: The view to be invalidated.
func resetViewStateInvalidation<V: View>(_ view: V) {
    dynamicPropertyDumper(view: view).resetInvalidationState()
}
