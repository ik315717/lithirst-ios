import UIKit
import MapKit

class LIMapViewController: LIUIViewController,
                           CLLocationManagerDelegate,
                           MKMapViewDelegate,
                           UISearchBarDelegate,
                           UITableViewDataSource,
                           UITableViewDelegate {
  
  enum tableViewGrabState {
    case Bottom
    case Normal
    case Top
  }
  
  @IBOutlet var contentView: UIView!
  @IBOutlet var mapView: MKMapView!
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var tableView: UITableView!
  @IBOutlet var tableViewArrowImageView: UIImageView!
  @IBOutlet var tableViewContainerView: UIView!
  @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet var tableViewPullView: UIView!
  
  var currentTableViewState = tableViewGrabState.Normal
  var locationManger: CLLocationManager!
  var userLocation: CLLocation?
  var userLocationUpdates : [CLLocationDistance] = []
  var venueList: Array<LIVenue> = []
  
  // Static Variable
  let locationSpan = MKCoordinateSpanMake(0.05, 0.05)
  let searchSpan = MKCoordinateSpanMake(0.015, 0.015)
  
  // Table View Heights
  var tableViewBottomHeight: CGFloat = 45.0
  var tableViewNormalHeight: CGFloat = 130.0
  var tableViewTopHeight: CGFloat {
    return self.contentView.frame.size.height - 45.0
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.getCurrentLocation()
    setUpMapView()
    setKeyboardToolBar()
    self.mapView.delegate = self
    self.mapView.showsUserLocation = true
    
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.register(UINib(nibName:LIVenueMapCell.className,
                                   bundle: nil),
                   forCellReuseIdentifier: LIVenueMapCell.className)
    self.searchBar.delegate = self
    
    let apiRequest = LIVenuesRequest.init()
    apiRequest.getVenues { venues in
      self.venueList = venues
      self.sortVenueListfromUserLocation()
      
      self.addVenuesToMap()
      self.tableView.reloadData()
    }
  }
  
  override func styleViews() {
    super.styleViews()
    
    self.setnavigationBar(title: NSLocalizedString("app_name", comment: ""))
    self.tableView.tableFooterView = UIView()

    self.tableViewContainerView.backgroundColor = UIColor.li_lightBlueColor
    self.tableViewContainerView.clipsToBounds = true
    self.tableViewContainerView.layer.cornerRadius = 25.0
    
    self.tableViewPullView.backgroundColor = UIColor.li_lightBlueColor
    self.tableViewPullView.clipsToBounds = true
    self.tableViewPullView.layer.cornerRadius = 25.0
  }
  
  // MARK: Button Presses
  
  @IBAction func userLocationButtonPress(_ sender: UIButton) {
    if let location = userLocation {
      setMapLocation(locationToPanTo: location, cordinateSpan: self.locationSpan)
    }
  }
  
  
  // MARK: Location Manager Delegate
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    if let pastLocation = userLocation, let location = locations.first {
      let meters = location.distance(from: pastLocation)
      if meters > 10 || userLocationUpdates.count < 5 {
        setMapLocation(locationToPanTo: location, cordinateSpan: self.locationSpan)
      }
      
      
      userLocationUpdates.append(meters)
      if userLocationUpdates.reduce(0, +) / Double(userLocationUpdates.count) < 5.0
        && userLocationUpdates.count > 10 {
        locationManger.stopUpdatingLocation()
      }
    }
    
    if let location = locations.first {
      userLocation = location
      self.sortVenueListfromUserLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Location Manager Error: \(error.localizedDescription)")
  }
  
  // MARK: MKMapView Delegate Methods 
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if (annotation is MKUserLocation) {
      return nil
    }
    
    let annotationView = MKPinAnnotationView()
    annotationView.annotation = annotation
    annotationView.canShowCallout = true
    
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    
    //Remove any previous Gesture Recognizers
    for recognizer in view.gestureRecognizers ?? [] {
      view.removeGestureRecognizer(recognizer)
    }
    
    let gestureRecognizer =
      UITapGestureRecognizer(target: self, action:#selector(LIMapViewController.calloutTapped))
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  func calloutTapped(sender:UITapGestureRecognizer) {
    guard let annotation = (sender.view as? MKAnnotationView)?.annotation as? LIPointAnnotation else { return }
    let view = sender.view as? MKAnnotationView
    
    if (view?.isSelected)! {
      self.pushDetailsViewControllerWith(venue: annotation.venue)
    }
  }
  
  // MARK: Map Private Methods
  
  func addVenuesToMap() {
    for venue in venueList {
      let annotation = LIPointAnnotation(venue: venue)
      
      if let latitude = venue.latitude, let longitude = venue.longitude {
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.coordinate = coordinate
        annotation.title = venue.name
        mapView.addAnnotation(annotation)
      }
    }
  }
  
  func getCurrentLocation() {
    locationManger = CLLocationManager()
    locationManger.delegate = self
    locationManger.desiredAccuracy = kCLLocationAccuracyBest
    locationManger.requestWhenInUseAuthorization()
    
    if CLLocationManager.locationServicesEnabled() {
      locationManger.startUpdatingLocation()
    }
  }
  
  func handleMapPanGesture() {
    locationManger.stopUpdatingLocation()
  }
  
  func sortVenueListfromUserLocation() {
    if let locationCoordinate = self.userLocation?.coordinate,
       let location = self.userLocation,
       self.venueList.count > 0 {
      
      func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: location)
      }
      
      self.venueList = self.venueList.sorted(by: { (venue1, venue2) -> Bool in
        venue1.distance(to: location) < venue2.distance(to: location)
      })
      
      self.tableView.reloadData()
    }
  }
  
  func setMapLocation(locationToPanTo location: CLLocation, cordinateSpan: MKCoordinateSpan) {
    let region = MKCoordinateRegion(center: location.coordinate, span: cordinateSpan)
    mapView.setRegion(region, animated: true)
  }
  
  func setUpMapView() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(LIMapViewController.handleMapPanGesture))
    mapView.addGestureRecognizer(panGesture)
  }
  
  // MARK: Navigation
  
  func pushDetailsViewControllerWith(venue: LIVenue?) {
    if let selectedVenue = venue {
      let venueDetailsViewController = LIVenueDetailViewController(venue: selectedVenue)
      self.navigationController?.pushViewController(venueDetailsViewController, animated: true)
    }
  }
  
  // MARK: TableView Delegate Methods
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.pushDetailsViewControllerWith(venue: self.venueList[indexPath.row])
  }
  
  // MARK: TableView DataSource Methdos
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.venueList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: LIVenueMapCell = tableView.dequeueReusableCell(withIdentifier: LIVenueMapCell.className) as! LIVenueMapCell
    
    let venue : LIVenue = self.venueList[indexPath.row]
    cell.venueLabel.text = venue.name
    cell.venueDealLabel.text = venue.activeDealTitle
    if let location = self.userLocation {
      let distance = venue.distance(to: location)
      
      if distance != Double(DBL_MAX) {
        let miles = LIMathHelper.converttoMiles(from: distance)
        let distanceString = String(format: NSLocalizedString("map_table_view_distance_format",
                                                              comment: ""), Float(miles))
        cell.venueDistanceLabel.text = distanceString
      }

    }

    
    return cell
  }
  
  
  // MARK: Table View Containter Methods
  
  @IBAction func tableViewContainerSwipeGesture(_ swipeGesture: UISwipeGestureRecognizer) {
    
    switch currentTableViewState {
    case .Bottom:
      if swipeGesture.direction == .up {
        currentTableViewState = .Normal
        tableViewHeightConstraint.constant = tableViewNormalHeight
      }
    case .Normal:
      if swipeGesture.direction == .up {
        currentTableViewState = .Top
        tableViewHeightConstraint.constant = tableViewTopHeight

        UIView.animate(withDuration: 1.0,
                       delay: 0.5,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: {
                        self.tableViewArrowImageView.isHidden = true
        }, completion: nil)
      } else if  swipeGesture.direction == .down {
        currentTableViewState = .Bottom
        tableViewHeightConstraint.constant = tableViewBottomHeight
      }
    case .Top:
      if swipeGesture.direction == .down {
        currentTableViewState = .Normal
        tableViewHeightConstraint.constant = tableViewNormalHeight
        UIView.animate(withDuration: 1.0,
                       delay: 0.5,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: {
                        self.tableViewArrowImageView.isHidden = false
        }, completion: nil)
      }
    }
    
    UIView.animate(withDuration: 0.40) {
      self.view.layoutIfNeeded()
    }
  }

  // MARK: Search Bar Delegate
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let searchText = searchBar.text {
      let geoCoder = CLGeocoder()
      self.view.endEditing(true)
      weak var weakSelf = self
      
      geoCoder.geocodeAddressString(searchText) { (placeMarkArray, error) in
        if let placeMark = placeMarkArray?.first {
          if let location = placeMark.location, let weakSelfRef = weakSelf {
            weakSelfRef.locationManger.stopUpdatingLocation()
            weakSelfRef.setMapLocation(locationToPanTo: location, cordinateSpan: self.searchSpan)
          }
        }
      }
    }
  }
  
  // MARK: Private Methods
  
  func setKeyboardToolBar() {
    let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
    numberToolbar.barStyle = UIBarStyle.black
    numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,
                                           target: nil,
                                           action: nil),
      UIBarButtonItem(title: "Cancel",
                      style: UIBarButtonItemStyle.plain,
                      target: self,
                      action: #selector(LIMapViewController.stopSearch))]
    numberToolbar.sizeToFit()
    numberToolbar.tintColor = UIColor.white
    self.searchBar.inputAccessoryView = numberToolbar
  }
  
  func stopSearch() {
    self.searchBar.endEditing(true)
  }
  

}
