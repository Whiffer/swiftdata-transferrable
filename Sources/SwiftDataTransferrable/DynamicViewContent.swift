//
//  DynamicViewContent.swift
//  swiftdata-transferrable
//
//  Created by Chuck Hartman on 12/3/23.
//

import SwiftUI
import SwiftData

extension DynamicViewContent {
    
    public func dropDestination<Model>(for payloadType: Model.Type = Model.self, action: @escaping ([Model], Int) -> Void) -> some DynamicViewContent where Model : PersistentModel {
        
        return self.dropDestination(for: PersistentIdentifier.self) { ids, offset in
            
            let modelContext = SwiftDataDragAndDropController.shared.modelContext!
            var modelObjects = Array<Model>()
            for id in ids {
                if let modelObject: Model = id.persistentModel(from: modelContext) {
                    modelObjects.append(modelObject)
                }
            }
            return action(modelObjects, offset)
        }
    }
    
}
