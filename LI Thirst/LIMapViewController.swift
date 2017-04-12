import UIKit
import MapKit

class LIMapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
  
  @IBOutlet var contentView: UIView!
  @IBOutlet var mapView: MKMapView!
  @IBOutlet var searchBar: UISearchBar!
  
  var locationManger: CLLocationManager!
  var venueList: Array<LIVenue> = [] {
    didSet {
      
    }
  }
  var userLocation: CLLocation?
  var userLocationUpdates : [CLLocationDistance] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.edgesForExtendedLayout = []
    self.getCurrentLocation()
    self.mapView.showsUserLocation = true
    self.searchBar.delegate = self
    
    let apiRequest = LIVenuesRequest.init()
    apiRequest.getVenues { venues in
      self.venueList = venues
      self.addVenuesToMap()
    }
  }
  
  // MARK: Button Presses
  
  @IBAction func userLocationButtonPress(_ sender: UIButton) {
    if let location = userLocation {
      setMapLocation(locationToPanTo: location)
    }
  }
  
  // MARK: Map Private Methods
  
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
      setMapLocation(locationToPanTo: location)
      
      let meters = location.distance(from: pastLocation)
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
