import Foundation
import ObjectMapper

class LIVenue : Mappable {
    
  var address : String?
  var city : String?
  var latitude : Double?
  var longitude : Double?
  var name : String?
  var state : String?
  var venueID : Int?
  var deals : Array<LIDeal> = []
  
  var activeDealTitle : String? {
    return self.getActiveDeal()?.title
  }

  required init?(map: Map) {
    // check if a required property exists within the JSON.
    // if map.JSON["name"] == nil {
    //   return nil
    // }
  }
  
  func mapping(map: Map) {
    address   <- map["address"]
    city      <- map["city"]
    latitude  <- (map["latitude"], LICustomMapTransforms.stringToDoubleTransform())
    longitude <- (map["longitude"], LICustomMapTransforms.stringToDoubleTransform())
    name      <- map["name"]
    state     <- map["state"]
    venueID   <- map["id"]
    deals     <- (map["deals"], LICustomMapTransforms.jsonDealarrayToLIDealTransform())
  }
  
  
  // MARK: Public functions
  
  public func getActiveDeal() -> LIDeal? {
    for deal in self.deals {
      if let expirationDate = deal.expirationDate,
         let days = deal.daysAvailable {
        
        if Date() < expirationDate {
          if let dealStartTime = deal.startTimeAdjustedForDay,
             let dealEndTime = deal.endTimeAdjustedForDay {
            let fallsBetween = (dealStartTime...dealEndTime).contains(Date().localizedDate())

            if fallsBetween && days.contains(LIDay.getDayOfWeek()) {
                return deal
            }
          }
        }
      }
    }
    
    return nil
  }
}
