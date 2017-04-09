import UIKit
import MapKit

class LIMapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
  
  @IBOutlet var contentView: UIView!
  @IBOutlet var mapView: MKMapView!
  @IBOutlet var searchBar: UISearchBar!
  
  var locationManger: CLLocationManager!
  var venueList: Array<LIVenue> = []
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
    }
  }
  
  // MARK: Location Manager Delegate
  
  func getCurrentLocation() {
    locationManger = CLLocationManager()
    locationManger.delegate = self
    locationManger.desiredAccuracy = kCLLocationAccuracyBest
    locationManger.requestWhenInUseAuthorization()
    
    if CLLocationManager.locationServicesEnabled() {
      locationManger.startUpdatingLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    if let pastLocation = userLocation, let location = locations.first {
      let meters = location.distance(from: pastLocation)
      userLocationUpdates.append(meters)
      
      if userLocationUpdates.reduce(0, +) / Double(userLocationUpdates.count) < 5.0
        && userLocationUpdates.count > 5 {
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
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
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    if let searchText = searchBar.text {
      print(searchText)
      let geoCoder = CLGeocoder()
      geoCoder.geocodeAddressString(searchText) { (placeMarkArray, error) in
        if let placeMark = placeMarkArray?.first {
          if let location = placeMark.location {
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
          }
        }
      }
    }
  }
  
}
