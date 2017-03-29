import Foundation
import Nimble
import Quick

class NSObjectSpec : QuickSpec {
  override func spec() {
    describe("className") {
      it("property className equals name of class") {
        let testClassName = NSObject().className
        
        expect(testClassName).to(equal("NSObject"))
      }
    }
  }
}
