//
//  MapViewController.swift
//  Ta no mapa
//
//  Created by Bruno Alves on 07/01/19.
//  Copyright © 2019 Bruno Alves. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var map: MKMapView!
    
    lazy var usersRequest = UsersRequest()
    var users: UsersModel?
    var annotations: [MKPointAnnotation]?

    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        loadUsers()
    }
    
    private func loadUsers() {
        usersRequest.users(success: { [unowned self] (users) in
            //
            self.users = users
            DispatchQueue.main.async {
                self.putPointsOnMap()
            }
        }) { (error) in
            //
            print("Deu erro")
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
    
    @IBAction func logout(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let link = view.annotation?.subtitle {
            let url = URL(string: link!)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
        
        pinAnnotationView.pinTintColor = .purple
        pinAnnotationView.animatesDrop = true
        
        return pinAnnotationView
    }
}
