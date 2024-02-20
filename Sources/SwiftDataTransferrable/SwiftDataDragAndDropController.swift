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
    
}
