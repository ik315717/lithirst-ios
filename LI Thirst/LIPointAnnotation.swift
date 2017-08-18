import Foundation
import MapKit

class LIPointAnnotation: MKPointAnnotation {
  var venue : LIVenue!
  
  init(venue: LIVenue) {
    self.venue = venue
  }
}
