import Foundation
import ObjectMapper
import SwiftyJSON

class LIVenueFixture {
  class func fixtureObject() -> LIVenue {
    var venue : LIVenue?
    
    if let path = Bundle.main.path(forResource: "LIVenue", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        let jsonObj = JSON(data: data)
        if jsonObj != JSON.null {
          venue = Mapper<LIVenue>().map(JSONObject: jsonObj.rawValue)!
        }
      } catch let error {
        print(error.localizedDescription)
      }
    }
    
    return venue!
  }
  
  class func fixtureWebResponse() -> Data {
    var webData : Data?
    
    if let path = Bundle.main.path(forResource: "LIVenueWebResponse", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        webData = data
      } catch let error {
        print(error.localizedDescription)
      }
    }
    
    return webData!
  }
}
