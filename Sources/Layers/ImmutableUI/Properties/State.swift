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

struct OwnerEntry {
    private let owner: Element
    /// Contains a referece to the world, should this be just a simple pointer?, or unowned?
    private weak var world: World?

    init(_ owner: Element, _ world: World) {
        self.owner = owner
        self.world = world
    }

    func invalidate() {
        guard let world = world else {
            fatalError("Element \(owner) can not be invalidated due world")
        }
        world.markAsInvalid(owner.elementID)
    }
}

#if DEBUG
extension OwnerEntry {
    func printDescription() {
        print("Owner: \(owner): \(owner.elementID.seed) ")
    }
}
#endif

@propertyWrapper
public struct State<Value>: DynamicProperty {
    /// The content store in the state.
    private let value: Ref<Value>

    /// Flag which contains the read state access, if it was read or not.
    private var bodyReadAccessFootprint: Ref<Bool> = Ref(false)

    /// Indicates if the `State` should invalidate the owner or not.
    ///
    /// - Note: Check `buildElementTree` to figure it out how it works.
    private var shouldInvalidate: Ref<Bool> = Ref(false)

    /// A reference to the entry. This thing should be changed to a pointer to avoid retain release?.
    /// If the state exists it has an owner at least.
    ///
    /// This variable is changed every tree recreation maybe is better change the `Ref` for an actual
    /// pointer to avoid retain release, it should be safe if the pointer is stored in the world or some
    /// other place.
    ///
    /// - Note: The owner of the `State` is always an Element.
    var owner: Ref<OwnerEntry?> = Ref(nil)

    /// A flag to allow only the body to ready when there is not owner.
    ///
    /// - Note: Easy to glitch this on multithread environments, this must be locked.
    /// - TODO: Lock this.
    private var isBodyReading: Ref<Bool> = Ref(false)

    private let derivedBindings: Ref<[() -> Void]> = Ref([])

    public var wrappedValue: Value {
        get {
            // If there is an access before body element creation kill it,
            // bad use of state.
            precondition(owner.content != nil || isBodyReading.content,
                         ErrorMessages.stateUsedBeforeBodyCreation)

            bodyReadAccessFootprint.content = true
            return value.content
        }
        nonmutating set {
            // If there is an access before body element creation kill it,
            // bad use of state.
            precondition(owner.content != nil,
                         ErrorMessages.stateUsedBeforeBodyCreation)

            value.content = newValue
            // Alert the rest of derived binding about an update.
            for binding in derivedBindings.content {
                binding()
            }
            // Invalidate the owner's state only if the state was
            // read otherwise avoid the invalidation.
            guard bodyReadAccessFootprint.content else { return }
            // Check if the state has to do an invalidation, if the variable
            // was written but never read there is no need to invalidate.
            guard shouldInvalidate.content else { return }

            // The sate was changed, it must invalidate the owner.
            owner.content?.invalidate()
        }
    }

    public init(wrappedValue: Value) {
        value = Ref(wrappedValue)
    }

    public var projectedValue: Binding<Value> {
        // Create a new binding and attache it to the state taking advantage
        // the closure capture mechanism.
        // Avoid using wrappedValue in order to be able to know if the state
        // was read or not. If it was read it means that some element
        // in the body is reading from that variable.
        let binding = Binding(getter: { value.content },
        setter: {
            value.content = $0
            // Invalidate the owner's state only if the state was
            // read otherwise avoid the invalidation.
            guard bodyReadAccessFootprint.content else { return }
            // The value was already changed check if this is really necessary.
            owner.content?.invalidate()
        }, derive: { binding in
            derivedBindings.content.append(binding.onStateUpdated)
        })

        derivedBindings.content.append(binding.onStateUpdated)

        return binding
    }

    // MARK: Dynamic property

    /// Checks if the `State` was read, if it was read mark it as an invalidator `State`. This allows
    /// the `State` to invalidate the Owner.
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
extension State {
    public func printDescription() {
        owner.content?.printDescription()
    }
}
#endif
