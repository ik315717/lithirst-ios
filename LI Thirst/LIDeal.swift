import Foundation
import ObjectMapper

class LIDeal : Mappable {
  
  var dealID : Int?
  var description : String?
  var endTime : Date?
  var expirationDate : Date?
  var startTime : Date?
  var title : String?
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    dealID      <- map["id"]
    description <- map["description"]
    endTime     <- (map["end_time"], DateTransform())
    expirationDate <- (map["expiration"], DateTransform())
    startTime   <- (map["start_time"], DateTransform())
    title       <- map["title"]
  }
}
