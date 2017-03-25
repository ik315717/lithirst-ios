import Foundation
import Quick
import Nimble

class NSObjectSpec : QuickSpec {
  override func spec() {
    describe("className") {
      it("property className equals name of class") {
        let testClass = NSObject()
        let testClassName = testClass.className
        expect(testClassName).to(equal("NSObject"))
      }
    }
  }
}
