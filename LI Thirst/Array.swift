import Foundation

extension Array where Element: FloatingPoint {
  /// Returns the sum of all elements in the array
  var total: Element {
    return reduce(0, +)
  }
  /// Returns the average of all elements in the array
  var average: Element {
    return isEmpty ? 0 : total / Element(count)
  }
}

extension Array where Element: Equatable {
  mutating func remove(object: Element) {
    if let index = index(of: object) {
      remove(at: index)
    }
  }
}
