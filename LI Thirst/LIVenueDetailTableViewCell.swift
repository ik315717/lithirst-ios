import UIKit

class LIVenueDetailTableViewCell: UITableViewCell {
 
  @IBOutlet var dealExpiration: UILabel!
  @IBOutlet var dealNameLabel: UILabel!
  @IBOutlet var dealDescriptionLabel: UILabel!
  @IBOutlet var expandableButtonImageView: UIImageView!
  @IBOutlet var dealDescriptionTopSpaceConstraint: NSLayoutConstraint!
  
  
  var isExpanded : Bool = false {
    didSet {
      if self.isExpanded {
        let transform = self.expandableButtonImageView.transform.rotated(by: CGFloat(M_PI / 2.0))
        self.expandableButtonImageView.transform = transform
      } else {
        let transform = self.expandableButtonImageView.transform.rotated(by: CGFloat(-1 * M_PI / 2.0))
        self.expandableButtonImageView.transform = transform
      }
    }
  }

  func timeAvailableString(deal: LIDeal) {
    var startTimeFormatted : String = ""
    var endTimeFormatted : String = ""
    var dayOfString : String = ""
    
    if let dayName = deal.getSoonestDayAvailable()?.dayName {
      dayOfString = dayName
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    
    if let startTime = deal.startTimeAdjustedForDay, let endTime = deal.endTimeAdjustedForDay {
      startTimeFormatted = dateFormatter.string(from: startTime)
      endTimeFormatted = dateFormatter.string(from: endTime)
    }

    if !startTimeFormatted.isEmpty && !endTimeFormatted.isEmpty && !dayOfString.isEmpty {
      self.dealExpiration.text = String(format:NSLocalizedString("venue_detail_cell_time_deal_format",
                                        comment: ""),
                                        dayOfString,startTimeFormatted,endTimeFormatted)
    }

  }
}
