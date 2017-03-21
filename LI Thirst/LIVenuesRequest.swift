import Alamofire
import Foundation
import ObjectMapper

class LIVenuesRequest {
  public func getVenues(venues: @escaping (Array<LIVenue>) -> Void) {
    let venuesAPIRequest = LIAPIRequestPHP()
    venuesAPIRequest.request(methodType: .get,
                             path: "/specials-app/",
                             phpFile: "get_venues.php",
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


