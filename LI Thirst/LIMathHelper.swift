import Foundation
import MapKit

class LIMathHelper: NSObject {
  class func converttoMiles(from meters: CLLocationDistance) -> Double {
    return meters * 0.000621371192
  }
}
