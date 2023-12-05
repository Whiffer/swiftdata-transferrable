//
//  SwiftDataDragAndDropController.swift
//  swiftdata-transferrable
//
//  Created by Chuck Hartman on 10/18/23.
//

import SwiftUI
import SwiftData

internal class SwiftDataDragAndDropController {
    
    static let shared = SwiftDataDragAndDropController()
    private init() { }
    
    var exportedUTType: String = "com.[your team].persistentModelID"
    var modelContext: ModelContext?
    
    var modelObjects: [any PersistentModel]?
    
    var isValidationPending = true
    var isDragActive = false
    var dropProposal: DropProposal?
    
    // Dragging onInsert
    var onInsertAction: OnInsertAction?
    var onInsertTo: Int = 0
    var onInsertItemProviders: [NSItemProvider]?

    func onInsertItems() async -> Void {
        if let itemProviders = onInsertItemProviders,
           let action = onInsertAction {
            
            // Map [NSItemProvider] to [PersistentIdentifier]
            var persistentModelIDs = Array<PersistentIdentifier>()
            for itemProvider in itemProviders {
                if let persistentModelID = await itemProvider.persistentModelID() {
                    persistentModelIDs.append(persistentModelID)
                }
            }
            
            action(onInsertTo, persistentModelIDs)
        }
    }
    
}
