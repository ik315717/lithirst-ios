import Foundation
import Nimble
import ObjectMapper
import Quick


class LIVenueSpec : QuickSpec {
  override func spec() {
    describe("map") {
      var venueModel : LIVenue?
      
      beforeEach {
        let jsonDictionary: [String: Any] = [
          "venue_id":"1",
          "name":"Verde Kitchen & Cocktails",
          "address":"70 E Main St, Bay Shore, NY 11706",
          "latitude":"40.722567",
          "longitude":"-73.246128"]
        venueModel = Mapper<LIVenue>().map(JSONObject: jsonDictionary)
      }
      
      it("venueObjectModel should be properly configured", closure: {
        expect(venueModel?.address).to(equal("70 E Main St, Bay Shore, NY 11706"))
        expect(venueModel?.latitude).to(equal(40.722567))
        expect(venueModel?.longitude).to(equal(-73.246128))
        expect(venueModel?.name).to(equal("Verde Kitchen & Cocktails"))
        expect(venueModel?.venueID).to(equal(1))
      })
    }
  }
}
