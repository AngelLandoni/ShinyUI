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

/// Hooks into the `Element`'s states using Boxlection to know when they changed and perform
/// an automatic invalidation.
///
/// - Note: SwiftUI uses this in the same way and Flutter use the setState, not sure which is better
///         from usability perspective.
/// - TODO: Try to avoid Mirror and use directly the metadata.
func updateViewStateOwner<V: View, S: Storable>(_ view: V,
                                                newOwner owner: Element,
                                                in storable: S) {
    // Iterate over each variable to get the dynamic properties,
    // and when ever some of them changes the context should know
    // and store the id if it to recalculate layout or redraw.
    for property in Mirror(reflecting: view).children {
        // Check if the element property is a state.
        guard let dynProp = property.value as? DynamicProperty else { continue }
        // Set the element as the owner, take in consideration that the
        // 'owner' is allocated in the heap so we are only copying the
        // address and the rest of the struct but the content of the pointer
        // is shared (Maybe instead of use `Box` we can use a simple pointer
        // to avoid retain release).
        dynProp.owner.content = OwnerEntry(owner, storable)
    }
}

/*func updateViewStateOwner(_ view: AnyView,
                          newOwner owner: ElementID,
                          world: World) {
    // TODO: Figure it out how Swift Runtime works, this function is not needed
    // now but will be very helpful in the future.
}*/
