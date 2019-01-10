//
//  ConfirmInsertionViewController.swift
//  Ta no mapa
//
//  Created by Bruno Alves on 09/01/19.
//  Copyright © 2019 Bruno Alves. All rights reserved.
//

import UIKit
import MapKit

class ConfirmInsertionViewController: UIViewController {
    
    var localization: LocalizationModel!
    lazy var localizationRequest = LocalizationRequest()
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.map.delegate = self
        loadPinOnMap()
    }
    
    private func loadPinOnMap() {
        let point = MKPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: localization.latitude!, longitude: localization.longitude!)
        point.title = "\(String(describing: localization.firstName)) \(String(describing: localization.lastName))"
        point.subtitle = localization.mediaURL
        map.addAnnotation(point)
        
        let zoomLocation = CLLocationCoordinate2D(latitude: localization.latitude!, longitude: localization.longitude!)
        let viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 200, 200)
        map.setRegion(viewRegion, animated: false)
    }
    
    private func postLocation() {
        localizationRequest.postNewLocation(localization: localization, success: { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }) { (_) in
            // alert
        }
    }

    @IBAction func confirm(_ sender: Any) {
        postLocation()
    }
}

extension ConfirmInsertionViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let link = view.annotation?.subtitle {
            let url = URL(string: link!)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "newPin")
        pinAnnotationView.pinTintColor = .purple
        pinAnnotationView.animatesDrop = true
        return pinAnnotationView
    }
}
