import Alamofire
import Foundation

class LIVenuesRequest {
  public func getVenues(webResponse: @escaping (Array<LIVenue>) -> Void) {
    let venuesAPIRequest = LIAPIRequestPHP()
    venuesAPIRequest.request(methodType: .get,
                             path: "/specials-app/",
                             phpFile: "get_venues.php",
                             success: { response in
                              if let dataResponse = response {
                              venuesAPIRequest.serializeJSON(response: dataResponse, rootkey: "venues", data: { venueList in
                                if venueList.count > 0 {
                                  
                                }
                              })
                              }
                             },
                             failure: {error in
                              print(error.localizedDescription)
                             })

  }
}


