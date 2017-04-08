import Foundation
import Nimble
import Quick

class LIVenuesRequestSpec : QuickSpec {
  override func spec() {
    describe("getVenues") {
      it("returns list of venues") {
        
        let venueRequest = LIVenuesRequest()
        waitUntil(action: { done in
          venueRequest.getVenues { venues in
            expect(venues.count).to(equal(4))
            
            let nedDevines = venues[0]
            let howl = venues[1]
            let theBurren = venues[3]
            
            expect(nedDevines.address).to(equal("Faneuil Hall Marketplace, " +
              "1 Faneuil Hall Marketplace, Boston, MA 02109"))
            expect(howl.latitude).to(equal(42.356648999999997))
            expect(howl.longitude).to(equal(-71.052625000000006))
            expect(theBurren.name).to(equal("The Burren"))
            expect(theBurren.venueID).to(equal(4))
            
            done()
          }
        })
      }
    }
  }
}
