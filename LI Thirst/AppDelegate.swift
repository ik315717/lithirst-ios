import CoreData
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions
    launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      self.window = UIWindow.init(frame: UIScreen.main.bounds)
      let mapViewController = LIMapViewController(nibName: LIMapViewController.className, bundle: nil)
      self.window?.rootViewController = UINavigationController(rootViewController: mapViewController)
      self.window?.makeKeyAndVisible()
    
      return true
  }
}
