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
    @IBOutlet weak var confirm: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.map.delegate = self
        loadPinOnMap()
    }
    
    private func loadPinOnMap() {
        let point = MKPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: localization.latitude!, longitude: localization.longitude!)
        point.title = "\(String(describing: localization.firstName!)) \(String(describing: localization.lastName!))"
        point.subtitle = localization.mediaURL
        map.addAnnotation(point)
        
        let zoomLocation = CLLocationCoordinate2D(latitude: localization.latitude!, longitude: localization.longitude!)
        let viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 200, 200)
        map.setRegion(viewRegion, animated: false)
        
        map.selectAnnotation(point, animated: true)
    }
    
    private func postLocation() {
        self.confirm.isEnabled = false
        self.confirm.setTitle("Postando localização...", for: .disabled)
        localizationRequest.postNewLocation(localization: localization, success: { [unowned self] in
            self.confirm.isEnabled = true
            self.dismiss(animated: true, completion: nil)
        }) { (_) in
            DispatchQueue.main.async {
                self.confirm.isEnabled = true
            }
            let alert = UIAlertController(title: nil, message: "Erro ao enviar sua localização. Deseja tentar novamente?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Tentar novamente", style: .default, handler: { [unowned self] (_) in
                self.postLocation()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func confirm(_ sender: Any) {
        postLocation()
    }
}

extension ConfirmInsertionViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "newPin")
        pinAnnotationView.pinTintColor = .purple
        pinAnnotationView.animatesDrop = true
        pinAnnotationView.canShowCallout = true
        
        let calloutButton = UIButton(type: .detailDisclosure)
        pinAnnotationView.rightCalloutAccessoryView = calloutButton
        pinAnnotationView.sizeToFit()
        
        return pinAnnotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let url = URL(string: (view.annotation?.subtitle!)!)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
}
