import Foundation
import ObjectMapper

class LIDay : Mappable, Equatable {
  
  var dayID : NSNumber?
  var dayName : String?
  
  //: MARK Object Lifecycle Methods
  
  init(_ dayID: NSNumber, dayName: String) {
    self.dayID = dayID
    self.dayName = dayName
  }
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    dayID   <- map["id"]
    dayName <- map["name"]
  }
  
  //: MARK Public Functions
  
  class func getDayOfWeek() -> LIDay {
    return LIDay(-1, dayName: Date().dayOfWeek())
  }
  
  //: MARK Equaitable 
  
  static func ==(lhs: LIDay, rhs: LIDay) -> Bool {
    return (lhs.dayName == rhs.dayName)
  }
}
