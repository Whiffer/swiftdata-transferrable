//
//  SwiftDataTransferrableScene.swift
//  SampleSwiftDataTransferrable
//
//  Created by Chuck Hartman on 8/27/24.
//

import SwiftUI
import SwiftData

@MainActor public struct SwiftDataTransferrableScene<Content>: Scene where Content: Scene {
    
    private let content: Content
    
    private var modelContainer: ModelContainer
    private var modelContext: ModelContext


    public init(schema: Schema, exportedUTType: String, @SceneBuilder content: () -> Content) {
        
        self.content = content()

        do {
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            modelContainer =  try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContext = modelContainer.mainContext
            
            SwiftDataDragAndDropController.shared.exportedUTType = exportedUTType
            SwiftDataDragAndDropController.shared.modelContext = modelContext

        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }

    }

    public var body: some Scene {
        content
            .modelContainer(modelContainer)

    }
}

