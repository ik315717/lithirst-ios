import CoreData
import OHHTTPStubs
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var testingApp : Bool {
    #if DEVELOPMENT
      return true
    #else
      return false
    #endif
  }

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
    if self.testingApp {
      stub(condition: isMethodGET() && isHost(LIAPIRequest.host) &&
        isPath(LIVenuesRequest.path + LIVenuesRequest.phpFile)) { _ in
          let stubData = LIVenueFixture.fixtureWebResponse()
          return OHHTTPStubsResponse(data: stubData, statusCode:200, headers:nil)
      }
    }
  }
}
