import Foundation
import UIKit

class LIVenueDetailViewController: LIUIViewController,
                                   UITableViewDataSource,
                                   UITableViewDelegate {
  
  @IBOutlet var currentDealDescriptionLabel: UILabel!
  @IBOutlet var currentDealTimeLeftLabel: UILabel!
  @IBOutlet var tableViewTitleLabel: UILabel!
  @IBOutlet var tableView: UITableView!
  
  var activeDeal : LIDeal? {
    get {
      return venue?.getActiveDeal()
    }
  }
  var venue : LIVenue?
  var otherDeals : Array<LIDeal> {
    get {
      if (self.venue?.deals) != nil {
        var allDeals = self.venue?.deals
        if let activeDeal = self.activeDeal {
          allDeals?.remove(object: activeDeal)
          return allDeals!
        }
        
        return allDeals!
      }
      
      return []
    }
  }
  
  // MARK: Object Lifecylce Methods
  
  init(venue: LIVenue) {
    super.init(nibName: nil, bundle: nil)
    
    self.venue = venue
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // MARK: View Controller Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.tableFooterView = UIView()
    self.tableView.register(UINib(nibName:LIVenueDetailTableViewCell.className,
                                  bundle: nil),
                            forCellReuseIdentifier: LIVenueDetailTableViewCell.className)
  }
  
  override func styleViews() {
    super.styleViews()
    
    self.navigationItem.title = self.venue?.name
    self.setnavigationBar(title: self.venue?.name)
    self.navigationController?.navigationBar.topItem?.title =
      NSLocalizedString("venue_detail_view_back_button_title", comment: "")
 
    // Current Deal Labels
    if (self.activeDeal != nil) {
      if let _ = activeDeal?.title,
         let dealDescription = activeDeal?.description {
        let hoursLeftString = NSLocalizedString("venue_detail_view_hours_left_format", comment: "")
        self.currentDealTimeLeftLabel.text = String.init(format: hoursLeftString, 3.4)
        self.currentDealTimeLeftLabel.font = UIFont.systemFont(ofSize: 26.0, weight: 0.175)
        
        self.currentDealDescriptionLabel.text = dealDescription
      }
      

      self.tableViewTitleLabel.font = UIFont.systemFont(ofSize: 22.0)
    } else {
      self.currentDealDescriptionLabel.text = NSLocalizedString("venue_detail_no_deal_available",
                                                                comment: "")
    }
    
    self.currentDealDescriptionLabel.font = UIFont.systemFont(ofSize: 20.0, weight: 0.0)
  }
  
  // MARK: TableView Delegate Methods
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! LIVenueDetailTableViewCell
    
    cell.isExpanded = !cell.isExpanded

    tableView.reloadData()
  }
  
  // MARK: TableView DataSource Methdos
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.otherDeals.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: LIVenueDetailTableViewCell =
      tableView.dequeueReusableCell(withIdentifier: LIVenueDetailTableViewCell.className)
        as! LIVenueDetailTableViewCell
    
    let deal = self.otherDeals[indexPath.row]
    cell.dealNameLabel.text = deal.title
    cell.timeAvailableString(deal: deal)
    
    if cell.isExpanded {
      cell.dealDescriptionLabel.text = deal.description
      cell.dealDescriptionTopSpaceConstraint.constant = 8
    } else {
      cell.dealDescriptionLabel.text = ""
      cell.dealDescriptionTopSpaceConstraint.constant = 0
    }
    
    return cell
  }
  
  // MARK: Private Methods
  

}
