import Foundation

struct LIVenue {
    
    var address : String
    var latitude : Double
    var longitude : Double
    var name : String
    var venueID : NSNumber
 
    init(address: String,
         latitude: Double,
         longitude: Double,
         name: String,
         venueID: NSNumber) {
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.venueID = venueID
    }
}
