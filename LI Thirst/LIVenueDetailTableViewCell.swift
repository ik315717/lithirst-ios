import UIKit

class LIVenueDetailTableViewCell: UITableViewCell {
 
  @IBOutlet var dealExpiration: UILabel!
  @IBOutlet var dealNameLabel: UILabel!
  @IBOutlet var expandableButtonImageView: UIImageView!

  func timeAvailableString(deal: LIDeal) {
    var startTimeFormatted : String = ""
    var endTimeFormatted : String = ""
    var dayOfString : String = ""
    
    if let dayName = deal.getSoonestDayAvailable()?.dayName {
      dayOfString = dayName
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h a"
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
