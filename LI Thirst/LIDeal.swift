import Foundation
import ObjectMapper

class LIDeal : Mappable, Equatable {
  
  var dealID : Int?
  var description : String?
  var daysAvailable : Array<LIDay>?
  var expirationDate : Date?
  var hoursActive : Float?
  var hoursRemaining : Int {
    get {
      if let endTime = self.endTimeAdjustedForDay {
        return Calendar.current.dateComponents([.hour], from: Date().localizedDate(),
                                               to: endTime).hour ?? 0
      }
      
      return 0
    }
  }
  var startTime : Date?
  var startTimeAdjustedForDay : Date?
  var endTimeAdjustedForDay : Date?
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
    
    if (self.startTime != nil) && (hoursActive != nil) {
      self.startTimeAdjustedForDay = Date().dateAdjustedToCurrentDay(date: self.startTime!)
      self.endTimeAdjustedForDay = startTimeAdjustedForDay?.addingTimeInterval(Double(self.hoursActive!) * 60.0 * 60.0)
    }

  }
  
  //: Public Functions
  
  func getSoonestDayAvailable() -> LIDay? {
    let currentDayID : NSNumber = LIDay.getDayOfWeek().dayID!
    var soonestDay : LIDay?

    // Search Through Upcoming Days
    let daysAhead : [LIDay] = (self.daysAvailable?.filter {(day: LIDay) in
      if let dayID = day.dayID {
        return dayID.intValue >= currentDayID.intValue
      } else {
        return false
      }})!
    
    for dealDay in daysAhead {
      if soonestDay == nil {
        soonestDay = dealDay
      }

      
      if let dealDayID = dealDay.dayID,
         let soonestDayID = soonestDay?.dayID {
          if (soonestDayID.intValue - currentDayID.intValue) > (dealDayID.intValue - currentDayID.intValue) {
              soonestDay = dealDay
          }
      }
    }
    
    // Search through Days next week
    if soonestDay == nil {
      let daysNextWeek : [LIDay] = (self.daysAvailable?.filter {(day: LIDay) in
        if let dayID = day.dayID {
          return dayID.intValue < currentDayID.intValue
        } else {
          return false
        }})!
      
      for dealDay in daysNextWeek {
        if soonestDay == nil {
          soonestDay = dealDay
        }
        
        if let dealDayID = dealDay.dayID,
          let soonestDayID = soonestDay?.dayID {
          if (currentDayID.intValue - soonestDayID.intValue) < (currentDayID.intValue - dealDayID.intValue) {
            soonestDay = dealDay
          }
        }
      }
    }
    
    return soonestDay
  }
  
  //: MARK Equaitable
  
  static func ==(lhs: LIDeal, rhs: LIDeal) -> Bool {
    return (lhs.dealID == rhs.dealID &&
            lhs.hoursActive == rhs.hoursActive &&
            lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.expirationDate == rhs.expirationDate)
  }
}
