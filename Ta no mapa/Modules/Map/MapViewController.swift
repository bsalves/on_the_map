//
//  MapViewController.swift
//  Ta no mapa
//
//  Created by Bruno Alves on 07/01/19.
//  Copyright © 2019 Bruno Alves. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var map: MKMapView!
    
    var annotations: [MKPointAnnotation]?

    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadUsers()
    }
    
    private func loadUsers() {
        usersRequest.users(success: { [unowned self] (users) in
            self.users = users
            DispatchQueue.main.async {
                self.putPointsOnMap()
            }
        }) { [unowned self] (error) in
            self.displayError(withAction: {
                self.loadUsers()
            })
        }
    }
    
    private func putPointsOnMap() {
        users?.results?.forEach({ (user) in
            if user.latitude != nil || user.longitude != nil {
                let point = MKPointAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: user.latitude!, longitude: user.longitude!)
                point.title = "\(user.lastName!)"
                point.subtitle = user.mediaURL
                map.addAnnotation(point)
            }
        })
    }
    
    private func reloadUsers() {
        map.annotations.forEach { (annotation) in
            map.removeAnnotation(annotation)
        }
        loadUsers()
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.reloadUsers()
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let url = URL(string: (view.annotation?.subtitle!)!)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "mapPin")
        
        pinAnnotationView.pinTintColor = .purple
        pinAnnotationView.animatesDrop = true
        pinAnnotationView.canShowCallout = true
        
        let calloutButton = UIButton(type: .detailDisclosure)
        pinAnnotationView.rightCalloutAccessoryView = calloutButton
        pinAnnotationView.sizeToFit()
        
        return pinAnnotationView
    }
}
