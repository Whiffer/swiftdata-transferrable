//
//  View.swift
//  swiftdata-transferrable
//
//  Created by Chuck Hartman on 10/18/23.
//

import SwiftUI
import SwiftData

extension View {
    
    public func swiftDataTransferrable(exportedUTType: String, modelContext: ModelContext) -> some View {
        
        SwiftDataDragAndDropController.shared.exportedUTType = exportedUTType
        SwiftDataDragAndDropController.shared.modelContext = modelContext
        return self
    }
    
    public func draggable<Model>(_ payload: @autoclosure @escaping () -> Model) -> some View where Model : PersistentModel {
        
        return self.draggable(payload().persistentModelID)
    }
    
    public func draggable<V, Model>(_ payload: @autoclosure @escaping () -> Model, @ViewBuilder preview: () -> V) -> some View where V : View, Model : PersistentModel {
        
        return self.draggable(payload().persistentModelID) {
            preview()
        }
    }

    public func dropDestination<Model>(for payloadType: Model.Type = Model.self, action: @escaping ([Model], CGPoint) -> Bool, isTargeted: @escaping (Bool) -> Void = { _ in } ) -> some View where Model : PersistentModel {
        
        return self.dropDestination(for: PersistentIdentifier.self) { ids, point in
            
            let modelContext = SwiftDataDragAndDropController.shared.modelContext!
            var modelObjects = Array<Model>()
            for id in ids {
                if let modelObject: Model = id.persistentModel(from: modelContext) {
                    modelObjects.append(modelObject)
                }
            }
            return action(modelObjects, point)
        } isTargeted: { targeted in
            isTargeted(targeted)
        }

    }

}
