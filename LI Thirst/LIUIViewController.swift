import Foundation
import UIKit

class LIUIViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.styleViews()
  }
  
  public func styleViews() {
    self.navigationController?.navigationBar.barTintColor = UIColor.li_lightBlueColor
    self.navigationController?.navigationBar.isTranslucent = false
    self.edgesForExtendedLayout = []
  }
  
  func setnavigationBar(title : String?) {
    // Navigation Bar
    self.navigationItem.title = title
    let navbarFont = UIFont.systemFont(ofSize: 28.0, weight: 0.25)
    self.navigationController?.navigationBar.titleTextAttributes =
      [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: navbarFont]
    self.navigationController?.navigationBar.tintColor = UIColor.white
  }
}
