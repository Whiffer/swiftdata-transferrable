//
//  SwiftDataDropDelegate.swift
//  swiftdata-transferrable
//
//  Created by Chuck Hartman on 10/18/23.
//

import SwiftUI
import SwiftData

internal struct SwiftDataDropDelegate<Model>: DropDelegate where Model : PersistentModel {
    
    private var modelContext: ModelContext
    private var action: ([Model], CGPoint) -> Bool
    private var isTargeted: (Bool) -> Void
    private var dropProposal: ([Model], CGPoint) -> DropProposal?
    
    private var controller = SwiftDataDragAndDropController.shared
    
    init(modelContext: ModelContext, action: @escaping ([Model], CGPoint) -> Bool, isTargeted: @escaping (Bool) -> Void, dropProposal: @escaping ([Model], CGPoint) -> DropProposal?) {
        self.modelContext = modelContext
        self.action = action
        self.isTargeted = isTargeted
        self.dropProposal = dropProposal
    }
    
    // DropDelegate protocol
    
    public func validateDrop(info: DropInfo) -> Bool {
        
        guard info.hasItemsConforming(to: [.persistentModelID]) else {
            return false
        }
        self.controller.isValidationPending = true

        Task {
            let itemProviders = info.itemProviders(for: [.persistentModelID])
            
            // Map [NSItemProvider] to [PersistentIdentifier]
            var persistentModelIDs = Array<PersistentIdentifier>()
            for itemProvider in itemProviders {
                if let persistentModelID = await itemProvider.persistentModelID() {
                    persistentModelIDs.append(persistentModelID)
                }
            }
            
            // Map [PersistentIdentifier] to [Model]
            let modelObjects: [Model] = persistentModelIDs.compactMap { $0.persistentModel(from: self.modelContext) }
            self.controller.modelObjects = modelObjects
            self.controller.isValidationPending = false
            self.controller.dropProposal = DropProposal(operation: .forbidden)
        }
        
        return true
    }
    
    public func performDrop(info: DropInfo) -> Bool {
        
        if self.controller.isValidationPending {
            return false
        } else {
            if let modelObjects = self.controller.modelObjects {
                let modelObjects = modelObjects.compactMap { $0 as? Model }
                // Send the Model objects to the View via the action method
                let dropResult = self.action(modelObjects, info.location)
                self.controller.modelObjects = nil
                self.controller.isDragActive = false
                return dropResult
            } else {
                return false
            }
        }
    }
    
    public func dropEntered(info: DropInfo) {
        
        self.controller.isDragActive = true
        self.isTargeted(true)
        return
    }
    
    public func dropUpdated(info: DropInfo) -> DropProposal? {
        
        if self.controller.isValidationPending {
            self.controller.dropProposal = DropProposal(operation: .forbidden)
        } else {
            if let modelObjects = self.controller.modelObjects {
                let modelObjects = modelObjects.compactMap { $0 as? Model }
                // Send the Model objects to the View via the dropProposal method
                self.controller.dropProposal = self.dropProposal(modelObjects, info.location)
            } else {
                self.controller.dropProposal = DropProposal(operation: .copy)
            }
        }
        return self.controller.dropProposal
    }
    
    public func dropExited(info: DropInfo) {
        
        self.controller.isDragActive = false
        self.isTargeted(false)
        return
    }
    
}
