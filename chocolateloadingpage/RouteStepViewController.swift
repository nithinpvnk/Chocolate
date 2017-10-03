//
//  RouteStepViewController.swift
//  chocolateloadingpage
//
//  Created by Nithin Kumar on 12/1/16.
//  Copyright © 2016 Nithin Kumar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RouteStepViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapViewStep: MKMapView!
    @IBOutlet weak var directionsText: UITextView!
    @IBOutlet weak var distance: UILabel!
    
    var routestep:MKRouteStep?
    var stepIndex:Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        mapViewStep.delegate = self
        mapViewStep.add((self.routestep?.polyline)!)
        mapViewStep.setVisibleMapRect((routestep!.polyline.boundingMapRect), animated: false)
        directionsText.text = self.routestep?.instructions;
        navigationItem.title = String .localizedStringWithFormat("Step %02lu", stepIndex!)
        distance.text = String .localizedStringWithFormat("%0.2f km", (routestep?.distance)! / 1000.0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue.withAlphaComponent(0.5)
        renderer.lineWidth = 2.5
        return renderer
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
