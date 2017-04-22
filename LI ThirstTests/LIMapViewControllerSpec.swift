import Foundation
import MapKit
import Nimble
import Quick
import UIKit

class LIMapViewControllerSpec : QuickSpec {
  let mapViewController = LIMapViewController()
  
  override func spec() {
    beforeEach {
      self.mapViewController.mapView = MKMapView()
      self.mapViewController.searchBar = UISearchBar()
      self.mapViewController.tableViewNormalHeight = 45.0
      self.mapViewController.tableViewBottomHeight = 130.0
      self.mapViewController.tableViewHeightConstraint = NSLayoutConstraint()
    }
    
    describe("viewDidLoad") {
      it("makes request to get venues", closure: {
        expect(self.mapViewController.venueList).toEventually(beAKindOf(Array<LIVenue>.self))
        
        self.mapViewController.viewDidLoad()
        
        expect(self.mapViewController.searchBar.delegate).toNot(beNil())
      })
    }
    
    describe("tableViewContainerSwipeGesture") {
      context("swipe Up, table at bottom position", {
        beforeEach {
          self.mapViewController.currentTableViewState = .Bottom
        }
        
        it("table moves to middle position", closure: {
          let gesture = UISwipeGestureRecognizer()
          gesture.direction = .up
          self.mapViewController.tableViewContainerSwipeGesture(gesture)
          expect(self.mapViewController.currentTableViewState.hashValue).to(equal(1))
        })
      })
      
      context("swipe up, table in normal position", {
        beforeEach {
          self.mapViewController.currentTableViewState = .Normal
        }
        
        
        it("table moves to top position", closure: {
          let gesture = UISwipeGestureRecognizer()
          gesture.direction = .up
          self.mapViewController.tableViewContainerSwipeGesture(gesture)
          expect(self.mapViewController.currentTableViewState.hashValue).to(equal(2))
        })
      })
      
      context("swipe up, table in top position", {
        beforeEach {
          self.mapViewController.currentTableViewState = .Top
        }
        
        
        it("table does not move", closure: {
          let gesture = UISwipeGestureRecognizer()
          gesture.direction = .up
          self.mapViewController.tableViewContainerSwipeGesture(gesture)
          expect(self.mapViewController.currentTableViewState.hashValue).to(equal(2))
        })
      })
      
      context("swipe down, table at bottom position", {
        beforeEach {
          self.mapViewController.currentTableViewState = .Bottom
        }
        
        it("table does not move", closure: {
          let gesture = UISwipeGestureRecognizer()
          gesture.direction = .down
          self.mapViewController.tableViewContainerSwipeGesture(gesture)
          expect(self.mapViewController.currentTableViewState.hashValue).to(equal(0))
        })
      })
      
      context("swipe down, table in normal position", {
        beforeEach {
          self.mapViewController.currentTableViewState = .Normal
        }
        
        it("table moves to bottom position", closure: {
          let gesture = UISwipeGestureRecognizer()
          gesture.direction = .down
          self.mapViewController.tableViewContainerSwipeGesture(gesture)
          expect(self.mapViewController.currentTableViewState.hashValue).to(equal(0))
        })
      })
      
      context("swipe down, table in top position", {
        beforeEach {
          self.mapViewController.currentTableViewState = .Top
        }
        
        it("table moves to middle position", closure: {
          let gesture = UISwipeGestureRecognizer()
          gesture.direction = .down
          self.mapViewController.tableViewContainerSwipeGesture(gesture)
          expect(self.mapViewController.currentTableViewState.hashValue).to(equal(1))
        })
      })
    }
  }
}
