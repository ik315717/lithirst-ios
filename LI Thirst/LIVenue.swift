import Foundation
import ObjectMapper

class LIVenue : Mappable {
    
  var address : String?
  var latitude : Double?
  var longitude : Double?
  var name : String?
  var venueID : NSNumber?

  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    address   <- map["address"]
    latitude  <- (map["latitude"],TransformOf<Double, NSNumber>)
    longitude <- map["longitude"]
    name      <- map["name"]
    venueID   <- map["venue_id"]
  }
}
