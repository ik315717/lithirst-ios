import Alamofire
import Foundation
import ObjectMapper

class LIVenuesRequest {
  static let path =  "/specials-app/"
  static let phpFile = "get_venues.php"
  
  static var requestURL: String {
    return LIAPIRequest.baseURL + path + phpFile
  }
  
  public func getVenues(venues: @escaping (Array<LIVenue>) -> Void) {
    let venuesAPIRequest = LIAPIRequest()
    venuesAPIRequest.request(methodType: .get,
                             path: LIVenuesRequest.path,
                             phpFile: LIVenuesRequest.phpFile,
                             success: { response in
                              if let dataResponse = response {
                              venuesAPIRequest.serializeJSON(response: dataResponse, rootkey: "venues", data: { venueList in
                                var venueListWithObjects : Array<LIVenue> = []
                                for venue in venueList {
                                  let venueModel = Mapper<LIVenue>().map(JSONObject: venue)
                                  
                                  if let venueObject = venueModel {
                                    venueListWithObjects.append(venueObject)
                                  }
                                }
                                
                                venues(venueListWithObjects)
                              })
                              }
                             },
                             failure: {error in
                              print(error.localizedDescription)
                             })
  }
}


