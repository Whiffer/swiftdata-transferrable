# swiftdata-transferrable

This package implements generic extensions to the `.draggable()` and `.dropDestination()` SwiftUI View modifiers to faclilitate direct Drag and Drop operations with SwiftData `PersistentModel` objects.

Since SwiftData `PersistentModel` objects are not `Codable` and they are not `Transferable`, instead of trying to drag and drop the `PersistentModel` objects themselves, this package extracts and drags the `PersistentIdentifier` struct from the corresponding `PersistentModel` object.  This works well for dragging because the `PersistentIdentifier` struct is already `Codable` and it can easily be made  `Transferable`.  The `PersistentIdentifier` struct also works well for dropping because it can be used to retrieve its corresponding `PersistentModel` object from the `ModelContext`.

A complete project that demonstrates how to use this package is available at: [https://github.com/Whiffer/SampleSwiftDataTransferrable](https://github.com/Whiffer/SampleSwiftDataTransferrable)
## Steps to Implement SwiftUI Drag and Drop with SwiftData objects

#### Add a Package Dependency for this package to your project
The Package URL is: [https://github.com/Whiffer/swiftdata-transferrable](https://github.com/Whiffer/swiftdata-transferrable)
#### Create an appropriate **Exported Type Identifier** for your project
Open your project settings, select the **Info** tab for your **Target**, then add a new **Exported Type Identifier** with the following properties:
```
Description:    "SwiftData Persistent Model ID"
Identifier:     "com.YourTeam.persistentModelID"
Conforms To:    "public.data"
```
#### Add the `.swiftDataTransferrable()` View modifer
Add a `.swiftDataTransferrable()` View modifer with appropriate argument values to the `ContentView` in your App struct:
```swift
        WindowGroup {
            ContentView()
                .swiftDataTransferrable(exportedUTType: "com.YourTeam.persistentModelID",
                                        modelContext: sharedModelContainer.mainContext)
        }
```
#### Add `.draggable()` View modifiers
The syntax of this package's generic `PersistentModel` `.draggable()` View modifier is the same as SwiftUI's generic `Transferrable` `.draggable()` View modifier.  Just supply the View modifier with the `PersistentModel` object to be dragged.
```swift
        Text("\(item.description) Drag Source Item")
        .draggable(item)
```
#### Add `.dropDestination()` View modifiers
The syntax for this package's generic `PersistentModel` `dropDestination()` View modifier is the same as SwiftUI's generic `Transferrable` `.dropDestination()` View modifier.  The `PersistentModel` items being dropped are the same `PersistentModel` objects that were dragged by the `.draggable()` View modifier.

```swift
        Text("Drop Target")
        .dropDestination(for: Item.self) { items, _ in
            for item in items {
                print("\(item.description) dropped on Drop Target")
            }
            return true
        }
```

The `dropPropsal` parameter is no longer available in Version 2.0 of this package.

~~In addition to the standard `for:`, `action:`, and `isTargeted:` paramenters, there is a new `dropProposal:` parameter to pass an optional closure that allows saving of a `DropProposal` struct during the drag and before the drop.  It is also used to inform the `DropDelegate` of the currently proposed `DropOperation` (e.g. `.copy`, `.move` and `.forbidden`).  There are examples of how to use this feature in the sample program linked above.~~

