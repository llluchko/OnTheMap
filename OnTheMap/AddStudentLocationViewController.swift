//
//  AddStudentLocationViewController.swift
//  OnTheMap
//
//  Created by Latchezar Mladenov on 4/18/16.
//  Copyright © 2016 Latchezar Mladenov. All rights reserved.
//

import UIKit
import MapKit

class AddStudentLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationTextBox: UITextField!
    @IBOutlet weak var linkToShareTextBox: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var latitude: Double?
    var longitude: Double?
    var location: String?
    var link: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        overlayView.hidden = true
        
        locationTextBox.delegate = self
        linkToShareTextBox.delegate = self
        submitButton.layer.cornerRadius = 5
        findOnTheMapButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.submitButton.hidden = true
        self.linkToShareTextBox.hidden = true
    }
    
    @IBAction func findOnTheMapTouchUp(sender: AnyObject) {
        if locationTextBox.text == "" {
            alert("Enter location")
            return
        }
        
        location = locationTextBox.text
        
        performUIUpdatesOnMain {
            self.activityIndicator.startAnimating()
            self.view.bringSubviewToFront(self.overlayView)
            self.overlayView.hidden = false
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location!, completionHandler: { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if let placemark = placemarks?[0] {
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                self.mapView.hidden = false
                self.findOnTheMapButton.hidden = true
                self.submitButton.hidden = false
                self.linkToShareTextBox.hidden = false
                self.locationTextBox.hidden = true
                
                let loc = CLLocationCoordinate2D(latitude: placemark.location!.coordinate.latitude, longitude: placemark.location!.coordinate.longitude)
                let region = MKCoordinateRegionMakeWithDistance(loc, 5000, 5000)
                self.mapView.setRegion(region, animated: true)
                
                self.latitude = placemark.location?.coordinate.latitude
                self.longitude = placemark.location?.coordinate.longitude
                performUIUpdatesOnMain() {
                    self.activityIndicator.stopAnimating()
                    self.overlayView.hidden = true
                }
            } else {
                performUIUpdatesOnMain() {
                    self.alert("Could not find location")
                }
            }
        })
}

    @IBAction func submitTouchUp(sender: AnyObject) {
        let data: [String: AnyObject] = [
            "uniqueKey": UdacityClient.sharedInstance().userID!,
            "firstName": UdacityClient.sharedInstance().firstName!,
            "lastName": UdacityClient.sharedInstance().lastName!,
            "mapString": self.location!,
            "mediaURL": self.linkToShareTextBox.text!,
            "latitude": self.latitude!,
            "longitude": self.longitude!
        ]

        ParseClient.sharedInstance().postLocations(data, completionHandler: { (result, error) in
            if error != nil {
                self.alert("Failed to create user location")
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    
    @IBAction func cancelTouchUp(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func alert(text:String) {
        performUIUpdatesOnMain() {
            let alertView = UIAlertView()
            alertView.message = text
            alertView.addButtonWithTitle("OK")
            alertView.show()
            self.activityIndicator.stopAnimating()
            self.overlayView.hidden = true
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}