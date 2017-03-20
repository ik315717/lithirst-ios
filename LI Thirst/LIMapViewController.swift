import UIKit

class LIMapViewController: UIViewController {
    
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var contentView: UIView!
  var venueList : Array<LIVenue> = []
    
  override func viewDidLoad() {
    super.viewDidLoad()

    let apiRequest = LIVenuesRequest.init()
    apiRequest.getVenues { venues in
      self.venueList = venues
    }
    
  }
}
