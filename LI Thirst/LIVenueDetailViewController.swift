import Foundation
import UIKit

class LIVenueDetailViewController: LIUIViewController {
  
  @IBOutlet var currentDealDescriptionLabel: UILabel!
  @IBOutlet var currentDealTimeLeftLabel: UILabel!
  @IBOutlet var tableViewTitleLabel: UILabel!
  @IBOutlet var venueDescriptionLabel: UILabel!
  
  var venue : LIVenue?
  
  init(venue: LIVenue) {
    super.init(nibName: nil, bundle: nil)
    
    self.venue = venue
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func styleViews() {
    super.styleViews()
    
    // Navigation Bar
    self.navigationController?.navigationBar.barTintColor = UIColor.li_lightBlueColor
    self.navigationController?.navigationBar.isTranslucent = false
    self.edgesForExtendedLayout = []
    
    self.navigationItem.title = self.venue?.name
    let navbarFont = UIFont.systemFont(ofSize: 28.0, weight: 0.25)
    self.navigationController?.navigationBar.titleTextAttributes =
      [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: navbarFont]
    self.navigationController?.navigationBar.tintColor = UIColor.white
    
    
  }
}
