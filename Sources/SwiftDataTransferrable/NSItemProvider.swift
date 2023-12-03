//
//  NSItemProvider.swift
//  swiftdata-transferrable
//
//  Created by Chuck Hartman on 10/18/23.
//

import Foundation
import SwiftData

extension NSItemProvider {
    
    @MainActor public func persistentModelID() async -> PersistentIdentifier? {
        
        typealias PersistentModelIDContinuation = CheckedContinuation<PersistentIdentifier?, Never>
        
        return await withCheckedContinuation { (continuation: PersistentModelIDContinuation) in
            _ = self.loadTransferable(type: PersistentIdentifier.self) { result in
                switch(result) {
                case .success(let persistentModelID):
                    continuation.resume(returning: persistentModelID)
                case .failure:
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
}
