import Foundation
import Nimble
import Quick

class LIAPIRequestSpec : QuickSpec {
  override func spec() {
    describe("request") { 
      it("request should fail", closure: {
        let baseURL = "http://www.google.com"
        
        let apiRequest = LIAPIRequest()
        apiRequest.request(methodType: .get, path: baseURL, phpFile: "noSuchFile.php", success: { response in
          
        }, failure: {error in
          print(error)
        })
      })
    }
  }
}
