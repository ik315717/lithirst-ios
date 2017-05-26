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
    return self.getActiveDeal()
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
  
  public func getActiveDeal() -> String? {
    for deal in self.deals {
      if let endDate = deal.endTime,
          let startDate = deal.startTime,
          let dealTitle = deal.title,
          let expirationDate = deal.expirationDate {
        
        if Date() < expirationDate {
          if let startDateAdjusted = Date().dateAdjustedToCurrentDay(date: startDate),
            let endDateAdjusted = Date().dateAdjustedToCurrentDay(date: endDate) {
              let fallsBetween = (startDateAdjusted...endDateAdjusted).contains(Date().localizedDate())
            
              if fallsBetween {
                return dealTitle
              }
          }
        }
      }
    }
    
    return nil
  }
}
