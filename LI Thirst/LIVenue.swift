import Foundation
import ObjectMapper

class LIVenue : Mappable {
    
  var address : String?
  var latitude : Double?
  var longitude : Double?
  var name : String?
  var venueID : Int?

  required init?(map: Map) {
    // check if a required property exists within the JSON.
    // if map.JSON["name"] == nil {
    //   return nil
    // }
  }
  
  func mapping(map: Map) {
    address   <- map["address"]
    latitude  <- (map["latitude"], LICustomMapTransforms.stringToDoubleTransform())
    longitude <- (map["longitude"], LICustomMapTransforms.stringToDoubleTransform())
    name      <- map["name"]
    venueID   <- (map["venue_id"], LICustomMapTransforms.stringToIntTransform())
  }
}
