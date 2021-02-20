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

protocol EnviromentProperty {
    var identifier: ObjectIdentifier { get }
    var content: Any? { get }
    func update(with value: Any?)
}

@propertyWrapper
public struct Enviroment<Value>: DynamicProperty, EnviromentProperty {
    
    var value: Ref<Value?> = Ref(nil)
    var owner: Ref<OwnerEntry?> = Ref(nil)
    var id: Int?
    
    public var wrappedValue: Value {
        get { return value.content! }
        nonmutating set { value.content = newValue }
    }
    
    public init() { }
    
    public init(wrappedValue: Value) {
        value.content = wrappedValue
    }
    
    public init<ID: Hashable>(wrappedValue: Value, id objectID: ID) {
        value.content = wrappedValue
        self.id = objectID.hashValue
    }
    
    var identifier: ObjectIdentifier {
        let type = Value.Type.self
        return ObjectIdentifier(type)
    }
    
    var content: Any? {
        value.content
    }
    
    /// Updates the content of the `Enviroment` only if the new content is the same type as `Value`.
    ///
    /// - Parameter with: The new content to set to the `Enviroment`
    func update(with newValue: Any?) {
        // Avoid nil values for now. This can happen if the Enviroment
        // is not instantiated yet.
        guard let newValue = newValue else { return }
        // Cast the new value to the correct type.
        guard let correctTypedValue = newValue as? Value else {
            fatalError(ErrorMessages.enviromentTypeDoesNotMatch)
        }
        value.content = correctTypedValue
    }
}

