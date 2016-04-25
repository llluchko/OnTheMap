//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Latchezar Mladenov on 3/23/16.
//  Copyright © 2016 Latchezar Mladenov. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
            
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Reply, target: self, action: #selector(MapViewController.logout))
            
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(MapViewController.refresh)), UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(MapViewController.add))]
        
        getStudentLocations()
        
    }
    
    func getStudentLocations() {
        ParseClient.sharedInstance().getLocations() { (result, error) in
            if error == nil {
                let annotations = self.makeLocations(result!)
                performUIUpdatesOnMain() {
                    self.mapView.addAnnotations(annotations)
                }
            } else {
                performUIUpdatesOnMain() {
                    self.alert(error!)
                }
            }
        }
    }
    
    func makeLocations(locations: [StudentLocation]) -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        for location in locations {
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let firstName = location.firstName
            let lastName = location.lastName
            let mediaURL = location.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        return annotations
    }
    
    func logout() {
        UdacityClient.sharedInstance().logout() { (result, error) in
            if result ==  "success" {
                performUIUpdatesOnMain() {
                    let controller = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController")
                    self.presentViewController(controller!, animated: true, completion: nil)
                }
            } else {
                self.alert(error!)
            }
        }
    }
        
    func refresh() {
        getStudentLocations()
    }
    
    func add() {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("AddStudentLocation")
        self.presentViewController(controller!, animated: true, completion: nil)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
        
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            if let subtitle = annotationView.annotation!.subtitle {
                if let url = NSURL(string: subtitle!) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
        }
    }
    
    func alert(text: String) {
        let alertView = UIAlertView()
        alertView.message = text
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }

}
