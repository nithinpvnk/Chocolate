//
//  HomeViewController.swift
//  chocolateloadingpage
//
//  Created by Nithin Kumar on 12/2/16.
//  Copyright © 2016 Nithin Kumar. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation

protocol HandleMapSearchHome {
    func dropPinZoomIn(placemark:MKPlacemark)
}

struct PreferencesKeys {
    static let savedItems = "savedItems"
}

protocol AddGeotificationsViewControllerDelegate {
    func addGeotificationViewController(controller: HomeViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String, eventType: EventType)
}

class HomeViewController: UIViewController, CLLocationManagerDelegate, HandleMapSearchHome, MKMapViewDelegate
{
    internal func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.025, 0.025)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    var selectedPin:MKPlacemark? = nil
    var resultSearchController:UISearchController? = nil
    let manager = CLLocationManager()
    var currentRoute:MKRoute?
    var routeOverlay: MKPolyline?
    @IBOutlet weak var mapView: MKMapView!
    var rad:Double = 0.0;
    var geotifications: [HomeGeoNotify] = []
    var delegate: AddGeotificationsViewControllerDelegate?
    var testView:MKAnnotationView?
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    //var routeOverlay: MKPolyline?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        manager.startUpdatingLocation()
        
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "homeloc") as! HomeTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for Destination"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        
        locationSearchTable.handleMapSearchDelegate = self
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        mapView.updateFocusIfNeeded()
        //mapView.updateUserActivityState(<#T##activity: NSUserActivity##NSUserActivity#>)
        
        loadAllGeotifications()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func loadAllGeotifications() {
        geotifications = []
        guard let savedItems = UserDefaults.standard.array(forKey: PreferencesKeys.savedItems) else { return }
        for savedItem in savedItems {
            guard let geotification = NSKeyedUnarchiver.unarchiveObject(with: savedItem as! Data) as? HomeGeoNotify else { continue }
            add(geotification: geotification)
        }
    }
    
    func saveAllGeotifications() {
        var items: [Data] = []
        for geotification in geotifications {
            let item = NSKeyedArchiver.archivedData(withRootObject: geotification)
            items.append(item)
        }
        UserDefaults.standard.set(items, forKey: PreferencesKeys.savedItems)
    }

   
    func add(geotification: HomeGeoNotify) {
        geotifications.append(geotification)
        mapView.addAnnotation(geotification)
        addRadiusOverlay(forGeotification: geotification)
        updateGeotificationsCount()
    }
    
    func remove(geotification: HomeGeoNotify) {
        if let indexInArray = geotifications.index(of: geotification) {
            geotifications.remove(at: indexInArray)
        }
        mapView.removeAnnotation(geotification)
        removeRadiusOverlay(forGeotification: geotification)
        updateGeotificationsCount()
    }

  
    func updateGeotificationsCount() {
        //segmentControl.titleForSegment(at: 1) = "GeoAlarm (\(geotifications.count))"
        navigationItem.rightBarButtonItem?.isEnabled = (geotifications.count < 20)
    }

    
    func removeRadiusOverlay(forGeotification geotification: HomeGeoNotify) {
        // Find exactly one overlay which has the same coordinates & radius to remove
        guard let overlays = mapView?.overlays else { return }
        for overlay in overlays {
            guard let circleOverlay = overlay as? MKCircle else { continue }
            let coord = circleOverlay.coordinate
            if coord.latitude == geotification.coordinate.latitude && coord.longitude == geotification.coordinate.longitude && circleOverlay.radius == geotification.radius {
                mapView?.remove(circleOverlay)
                break
            }
        }
    }
    
    func region(withGeotification geotification: HomeGeoNotify) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        // 2
        region.notifyOnEntry = (geotification.eventType == .first)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    func startMonitoring(geotification: HomeGeoNotify) {
        // 1
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(withTitle:"Error", message: "Geofencing is not supported on this device!")
            return
        }
        // 2
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showAlert(withTitle:"Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
        }
        // 3
        let region = self.region(withGeotification: geotification)
        // 4
        manager.startMonitoring(for: region)
    }
    
    func stopMonitoring(geotification: HomeGeoNotify) {
        for region in manager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
            manager.stopMonitoring(for: circularRegion)
        }
    }


    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.025, 0.025)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
   
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    //    {
    //        let location = locations[0]
    //
    //        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.03, 0.03)
    //        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    //        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
    //        mapView.setRegion(region, animated: true)
    //
    //        print(location.altitude)
    //        print(location.speed)
    //
    //        self.mapView.showsUserLocation = true
    //    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "favIcon"), for: .normal)
       button.addTarget(self, action: #selector(HomeViewController.onAdd), for: .touchUpInside)
       pinView?.leftCalloutAccessoryView = button
        testView = pinView
        return pinView
    }
    
    func getRadius()
    {
//        let alertController = UIAlertController(title: "Hey !", message: "Please Enter the radius " , preferredStyle: .alert)
//        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
//        alertController.addAction(defaultAction)
//        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
//            textField.placeholder = "Enter Radius :"
//        })
//        self.present(alertController, animated: true, completion: nil)
//        print(alertController.textFields!.description)
//        return 0
        let alert = UIAlertController(title: "Radius Desired",
                                      message: "Set the radius when you want the alarm",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction(title: "OK",
                               style: UIAlertActionStyle.default ) { (action: UIAlertAction) in
                                
                                if let alertTextField = alert.textFields?.first, alertTextField.text != nil {
                                   self.rad = (Double)(alertTextField.text!)!
                                }
//                                #selector(self.onAdd)
        }
        
        let cancel = UIAlertAction(title: "Cancel",
                                   style: UIAlertActionStyle.cancel,
                                   handler: nil)
        
        alert.addTextField { (textField: UITextField) in
            
            textField.placeholder = "Enter Radius here"
            
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func onAdd()
    {
        let coordinate = testView?.annotation?.coordinate
        let radius = 100.00
        let identifier = NSUUID().uuidString
        let note = "HI"
        let eventType: EventType = (segmentControl.selectedSegmentIndex == 1) ? .first : .geoAlarm
        addGeotificationViewController(controller: self, didAddCoordinate: coordinate!, radius: radius, identifier: identifier, note: note, eventType: eventType)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = .purple
            circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.4)
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Delete geotification
        let geotification = view.annotation as! HomeGeoNotify
        remove(geotification: geotification)
        saveAllGeotifications()
    }
    
    func addRadiusOverlay(forGeotification geotification: HomeGeoNotify) {
        mapView?.add(MKCircle(center: geotification.coordinate, radius: geotification.radius))
    }
    
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
   
}

extension HomeViewController: AddGeotificationsViewControllerDelegate {
    
    func addGeotificationViewController(controller: HomeViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String, eventType: EventType) {
        controller.dismiss(animated: true, completion: nil)
        // 1
        let clampedRadius = min(radius, manager.maximumRegionMonitoringDistance)
        let geotification = HomeGeoNotify(coordinate: coordinate, radius: clampedRadius, identifier: identifier, note: note, eventType: eventType)
        add(geotification: geotification)
        // 2
        startMonitoring(geotification: geotification)
        //saveAllGeotifications()
    }
    
}

