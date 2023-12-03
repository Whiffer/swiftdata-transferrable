//
//  UTType.swift
//  swiftdata-transferrable
//
//  Created by Chuck Hartman on 10/18/23.
//

import SwiftUI
import SwiftData

import UniformTypeIdentifiers

extension UTType {
    public static var persistentModelID: UTType { UTType(exportedAs: SwiftDataDragAndDropController.shared.exportedUTType) }
}

extension PersistentIdentifier: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .persistentModelID)
    }
}

extension PersistentIdentifier {
    public func persistentModel<Model>(from context: ModelContext) -> Model? where Model : PersistentModel {
        return context.model(for: self) as? Model
    }
}

