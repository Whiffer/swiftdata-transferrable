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
    
    public func dropDestination<Model>(for payloadType: Model.Type = Model.self,
                                       action: @escaping ([Model], CGPoint) -> Bool,
                                       isTargeted: @escaping (Bool) -> Void = { _ in },
                                       dropProposal: @escaping ([Model], CGPoint) -> DropProposal? = { _, _ in DropProposal(operation: .copy) }
    ) -> some View where Model : PersistentModel {
        
        let modelContext = SwiftDataDragAndDropController.shared.modelContext!
        let delegate = SwiftDataDropDelegate<Model>(modelContext: modelContext, action: action, isTargeted: isTargeted, dropProposal: dropProposal)
        return self.onDrop(of: [.persistentModelID], delegate: delegate)
    }

}

