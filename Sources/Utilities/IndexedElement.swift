import Foundation

/// A lightweight `Identifiable` wrapper pairing a sequence element with its index.
///
/// Xcode 16's iOS 18 SDK has a known bug where `ForEach(_:id:content:)` — the KeyPath-based
/// initializer — is ambiguous between `SwiftUICore.ForEach` and `SwiftUI.ForEach`. The plain
/// `ForEach(_:content:)` Identifiable-based initializer isn't affected, so this type makes
/// that usable anywhere the loop also needs an index.
struct IndexedElement<Element>: Identifiable {
    let index: Int
    let element: Element
    var id: Int { index }
}

extension Sequence {
    var indexedElements: [IndexedElement<Element>] {
        enumerated().map { IndexedElement(index: $0.offset, element: $0.element) }
    }
}
