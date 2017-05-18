import Alamofire
import Foundation
import ObjectMapper

class LIVenuesRequest {
  static let path =  "/venues.json"
  static let phpFile = ""
  
  public func getVenues(venues: @escaping (Array<LIVenue>) -> Void) {
    let venuesAPIRequest = LIAPIRequest()
    venuesAPIRequest.request(methodType: .get,
                             path: LIVenuesRequest.path,
                             success: { response in
                              if let dataResponse = response
                              {
                                venuesAPIRequest.serializeJSONArray(response: dataResponse, data: { venueList in
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
