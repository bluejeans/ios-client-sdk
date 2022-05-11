//
//  BJNSubscription.swift
//  HelloBlueJeans
//
//  Created by Thomas Roff on 29/03/22.
//

import BJNClientSDK

/// A utility class that provides an abstraction for managing onchange handlers.
/// - Tag: BJNSubscription
class BJNSubscription {
    weak var reference: Unsubscribable?
    let callbackID: CallbackId
    
    init(reference: Unsubscribable, callbackId: CallbackId) {
        self.reference = reference
        self.callbackID = callbackId
    }
    
    func unsubscibe() {
        self.reference?.unsubscribeFromChanges(self.callbackID)
    }
    
    func store(in collection: inout [BJNSubscription]) {
        collection.append(self)
    }
    
    deinit {
        self.unsubscibe()
    }
}

extension BJNObservable {
    /// Equivalent to onChange but returns a BJNSubscription, and sets initial state.
    func keepUpToDate(_ changeClosure: @escaping () -> Void) -> BJNSubscription {
        changeClosure()
        let callbackId = self.onChange {
            changeClosure()
        }
        return BJNSubscription(reference: self, callbackId: callbackId)
    }
}

protocol Unsubscribable: AnyObject {
    func unsubscribeFromChanges(_ callbackId: CallbackId)
}

extension BJNObservable: Unsubscribable {}
