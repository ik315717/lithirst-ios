import UIKit
import MapKit

class LIMapViewController: UIViewController,
                           CLLocationManagerDelegate,
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
  @IBOutlet var tableViewContainerView: UIView!
  @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet var tableView: UITableView!
  
  var currentTableViewState = tableViewGrabState.Normal
  var locationManger: CLLocationManager!
  var userLocation: CLLocation?
  var userLocationUpdates : [CLLocationDistance] = []
  var venueList: Array<LIVenue> = []
  
  // Table View Heights
  var tableViewBottomHeight: CGFloat = 45.0
  var tableViewNormalHeight: CGFloat = 130.0
  var tableViewTopHeight: CGFloat {
    return self.contentView.frame.size.height - 45.0
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.edgesForExtendedLayout = []
    self.getCurrentLocation()
    setUpMapView()
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
      
      self.addVenuesToMap()
      self.tableView.reloadData()
    }
  }
  
  // MARK: Button Presses
  
  @IBAction func userLocationButtonPress(_ sender: UIButton) {
    if let location = userLocation {
      setMapLocation(locationToPanTo: location)
    }
  }
  
  // MARK: Map Private Methods
  
  func setUpMapView() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(LIMapViewController.handleMapPanGesture))
    mapView.addGestureRecognizer(panGesture)
  }
  
  func handleMapPanGesture() {
    locationManger.stopUpdatingLocation()
  }
  
  func addVenuesToMap() {
    for venue in venueList {
      let annotation = MKPointAnnotation()
      
      if let latitude = venue.latitude, let longitude = venue.longitude {
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
      }
    }
  }
  
  func calculateRegionForVenues() {
    var coordinateList : [CLLocationCoordinate2D] = []
    
    for venue in venueList {
      if let latitude = venue.latitude, let longitude = venue.longitude {
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        coordinateList.append(coordinate)
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
  
  func setMapLocation(locationToPanTo location: CLLocation) {
    let span = MKCoordinateSpanMake(0.05, 0.05)
    let region = MKCoordinateRegion(center: location.coordinate, span: span)
    mapView.setRegion(region, animated: true)
  }
  
  // MARK: Location Manager Delegate
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    if let pastLocation = userLocation, let location = locations.first {
      let meters = location.distance(from: pastLocation)
      if meters > 10 || userLocationUpdates.count < 5 {
        setMapLocation(locationToPanTo: location)
      }

      
      userLocationUpdates.append(meters)
      if userLocationUpdates.reduce(0, +) / Double(userLocationUpdates.count) < 5.0
        && userLocationUpdates.count > 10 {
        locationManger.stopUpdatingLocation()
      }
    }
    
    if let location = locations.first {
      userLocation = location
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Location Manager Error: \(error.localizedDescription)")
  }
  
  // MARK: TableView Delegate Methods
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("Selected \(self.venueList[indexPath.row].name)")
  }
  
  // MARK: TableView DataSource Methdos
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.venueList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: LIVenueMapCell = tableView.dequeueReusableCell(withIdentifier: LIVenueMapCell.className) as! LIVenueMapCell
    
    cell.venueLabel.text = self.venueList[indexPath.row].name
    
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
      } else if  swipeGesture.direction == .down {
        currentTableViewState = .Bottom
        tableViewHeightConstraint.constant = tableViewBottomHeight
      }
    case .Top:
      if swipeGesture.direction == .down {
        currentTableViewState = .Normal
        tableViewHeightConstraint.constant = tableViewNormalHeight
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
            weakSelfRef.setMapLocation(locationToPanTo: location)
          }
        }
      }
    }
  }

}
