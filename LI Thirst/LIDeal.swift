import Foundation
import ObjectMapper

class LIDeal : Mappable {
  
  var dealID : Int?
  var description : String?
  var daysAvailable : Array<LIDay>?
  var expirationDate : Date?
  var hoursActive : Float?
  var startTime : Date?
  var title : String?
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    daysAvailable <- (map["days"], LICustomMapTransforms.jsonDayArrayToLIDayTransform())
    dealID      <- map["id"]
    description <- map["description"]
    expirationDate <- (map["expiration"], LIDateNoTimeTransform())
    hoursActive <- (map["hours_active"],LICustomMapTransforms.stringToFloatTransform())
    startTime   <- (map["start_time"], LIDateTimeTransform())
    title       <- map["title"]
  }
}
