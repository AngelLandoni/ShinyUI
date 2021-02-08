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

@propertyWrapper
public struct Binding<Value>: DynamicProperty {

    public typealias Getter = () -> Value
    public typealias Setter = (Value) -> Void
    public typealias Derive = (Self) -> Void

    private let getter: Getter
    private let setter: Setter
    private let derive: Derive

    /// Flag which contains the read state access, if it was read or not.
    ///
    /// - Note: This is a hacky implementation used to know about the read access, maybe we have
    ///         to find a better way to achieve the same.
    private let bodyReadAccessFootprint: Ref<Bool> = Ref(false)

    /// Indicates if the `State` should invalidate the owner or not.
    ///
    /// - Note: Check `buildElementTree` to figure it out how it works.
    private var shouldInvalidate: Ref<Bool> = Ref(false)

    /// A flag to allow only the body to ready when there is not owner.
    ///
    /// - Note: Easy to glitch this on multithread environments, this must be locked.
    /// - TODO: Lock this.
    private var isBodyReading: Ref<Bool> = Ref(false)

    var owner: Ref<OwnerEntry?> = Ref(nil)

    public var wrappedValue: Value {
        get {
            // If there is an access before body element creation kill it,
            // bad use of state.
            precondition(owner.content != nil || isBodyReading.content,
                         ErrorMessages.bindingUsedBeforeBodyCreation)

            bodyReadAccessFootprint.content = true
            return getter()
        }
        nonmutating set {
            // If there is an access before body element creation kill it,
            // bad use of state.
            precondition(owner.content != nil,
                         ErrorMessages.bindingUsedBeforeBodyCreation)

            setter(newValue)
        }
    }

    public init(getter: @escaping Getter,
                setter: @escaping Setter,
                derive: @escaping Derive) {
        self.getter = getter
        self.setter = setter
        self.derive = derive
    }

    public var projectedValue: Binding<Value> {
        // Creates a copy of `Self` but with this the `readAccessFootprint` is
        // new and we can have a different state for each copy of the Binder.
        // This is useful to know if the body is reading something from
        // the binder, if the body is reading the `Element` must be invalidated
        // otherwise there is NOT necessity of invalidation (we do not need
        // recreate the body due not state has not been read)
        let selfHalfCopy = Binding(getter: getter,
                                   setter: setter,
                                   derive: derive)
        // Let the State know that a new Binder was generated so it can let
        // us know when the state is updated.
        derive(selfHalfCopy)
        return selfHalfCopy
    }

    func onStateUpdated() {
        // Invalidate the owner only if the `Binder` has been read otherwise
        // avoid the invalidation.
        guard bodyReadAccessFootprint.content else { return }
        // The sate was changed, it must invalidate the owner.
        owner.content?.invalidate()
    }

    // MARK: Dynamic property

    /// Checks if the `Binding` was read, if it was read mark it as an invalidator `Binding`.
    /// This allows the `Binding` to invalidate the Owner.
    func configureInvalidationAfterElementCreation() {
        guard bodyReadAccessFootprint.content else { return }
        shouldInvalidate.content = true
    }

    func resetInvalidationState() {
        bodyReadAccessFootprint.content = false
        shouldInvalidate.content = false
    }

    func bodyStartReading() {
        isBodyReading.content = true
    }

    func bodyStopReading() {
        isBodyReading.content = false
    }
}

#if DEBUG
extension Binding {
    public func printDescription() {
        owner.content?.printDescription()
    }
}
#endif
