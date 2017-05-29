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
    let dayOfWeekName = Date().dayOfWeek()
    return LIDay(LIDay.getLIDayIDfor(dayString:dayOfWeekName), dayName: dayOfWeekName)
  }
  
  //: MARK Private Functions
  
  class func getLIDayIDfor(dayString: String) -> NSNumber {
    switch dayString {
    case "Monday":
      return 2
    case "Tuesday":
      return 3
    case "Wednesday":
      return 4
    case "Thursday":
      return 5
    case "Friday":
      return 6
    case "Saturday":
      return 7
    case "Sunday":
      return 8
    default:
      return 2
    }
  }
  
  //: MARK Equaitable 
  
  static func ==(lhs: LIDay, rhs: LIDay) -> Bool {
    return (lhs.dayName == rhs.dayName)
  }
}
