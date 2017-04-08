import UIKit
import OHHTTPStubs

class TestingAppDelegate: NSObject {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions
    launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    self.window = UIWindow.init(frame: UIScreen.main.bounds)
    let mapViewController = LIMapViewController(nibName: LIMapViewController.className, bundle: nil)
    self.window?.rootViewController = UINavigationController(rootViewController: mapViewController)
    self.window?.makeKeyAndVisible()
    
    self.setupStubbings()
    
    return true
  }
  
  private func setupStubbings() {
    stub(condition: isMethodGET() && isHost(LIAPIRequest.host) &&
      isPath(LIVenuesRequest.path + LIVenuesRequest.phpFile)) { _ in
        let stubData = LIVenueFixture.fixtureWebResponse()
        return OHHTTPStubsResponse(data: stubData, statusCode:200, headers:nil)
    }
  }
}
