//
//  DynamicViewContent.swift
//  swiftdata-transferrable
//
//  Created by Chuck Hartman on 12/3/23.
//

import SwiftUI
import SwiftData

public typealias OnInsertAction = (Int, [PersistentIdentifier]) -> Void

extension DynamicViewContent {
    
    public func onInsert<Model>(for payloadType: Model.Type = Model.self, perform action: @escaping (OnInsertAction) ) -> some DynamicViewContent where Model : PersistentModel {
        
        return onInsert(of: [.persistentModelID]) { to, itemProviders in
            
            let controller = SwiftDataDragAndDropController.shared
            controller.onInsertAction = action
            controller.onInsertTo = to
            controller.onInsertItemProviders = itemProviders

            Task {
                await controller.onInsertItems()
                
                controller.onInsertItemProviders = nil
                controller.onInsertTo = 0
                controller.onInsertAction = nil
            }
        }
    }
    
}
