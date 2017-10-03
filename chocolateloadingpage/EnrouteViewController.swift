//
//  EnrouteViewController.swift
//  chocolateloadingpage
//
//  Created by Nithin Kumar on 11/16/16.
//  Copyright © 2016 Nithin Kumar. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class EnrouteViewController: UIViewController, CLLocationManagerDelegate, HandleMapSearch, MKMapViewDelegate
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
    
    //var routeOverlay: MKPolyline?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        manager.startUpdatingLocation()
        
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "enroute") as! EnrouteTableViewController
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
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func getDirections()
    {
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
           // let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
           // mapItem.openInMaps(launchOptions: launchOptions)
            
            let request = MKDirectionsRequest()
            request.source = MKMapItem.forCurrentLocation()
            request.destination = mapItem
            let directions = MKDirections(request: request)
            request.requestsAlternateRoutes = false
            
                    directions.calculate(completionHandler: {(response, error) in
            
                        if  error != nil
                        {
                            let alertController = UIAlertController(title: "OOPs !", message: "Directions not Found" , preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else{
                            //self.showRoute(response!)
                            self.currentRoute = response?.routes.first
                            print(self.currentRoute!.steps)
                            self.routePlot(route: self.currentRoute!)
                        }
                        
                    })
        }
    }

    func routePlot(route: MKRoute)
    {
        if((routeOverlay) != nil)
        {
            mapView.remove(routeOverlay!)
        }
        routeOverlay = route.polyline
        mapView.add(routeOverlay!)
    }
    
    func showRoute(_ response: MKDirectionsResponse) {
        
        
        for route in response.routes {
           currentRoute = route
            mapView.add(route.polyline,level: MKOverlayLevel.aboveRoads)
            for step in route.steps {
                print(step.instructions)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
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
        button.addTarget(self, action: #selector(EnrouteViewController.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // let cell = sender as! CustomCell
        
        if segue.identifier == "steps" {
            
                let detailController = segue.destination as! RouteTableViewController
            
                detailController.route = currentRoute
            //print(detailController.route?.steps)
            }
        
    }
    
    @IBAction func routing(_ sender: UIButton)
    {
       // performSegue(withIdentifier: "steps", sender: sender)
    }

}


