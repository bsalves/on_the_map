//
//  InsertLocationViewController.swift
//  Ta no mapa
//
//  Created by Bruno Alves on 09/01/19.
//  Copyright © 2019 Bruno Alves. All rights reserved.
//

import UIKit
import CoreLocation

class InsertLocationViewController: UITableViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var link: UITextField!
    @IBOutlet weak var locale: UITextField!
    @IBOutlet weak var insert: UIButton!
    
    var localization: LocalizationModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localization = LocalizationModel()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewController = segue.destination as! ConfirmInsertionViewController
        nextViewController.localization = self.localization
    }
    
    private func isValidFields() -> Bool {
        return  !(name.text?.isEmpty)! &&
            !(lastName.text?.isEmpty)! &&
            !(link.text?.isEmpty)! &&
            !(locale.text?.isEmpty)!
    }
    
    private func searchLocale(success: @escaping () -> Void, finishedWithError: @escaping () -> Void) {
        if let locale = locale.text {
            
            let loading = UIAlertController(title: "Carregando...", message: nil, preferredStyle: .alert)
            self.present(loading, animated: true, completion: nil)
            
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(locale) { [unowned self] (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                    else {
                        finishedWithError()
                        loading.dismiss(animated: true, completion: nil)
                        return
                }
                self.localization.latitude = location.coordinate.latitude
                self.localization.longitude = location.coordinate.longitude
                success()
                loading.dismiss(animated: true, completion: nil)
                return
            }
        } else {
            finishedWithError()
        }
    }
    
    @IBAction func insert(_ sender: Any) {
        if self.isValidFields() {
            insert.setTitle("Buscando endereço...", for: .disabled)
            insert.isEnabled = false
            searchLocale(success: { [unowned self] in
                DispatchQueue.main.async {
                    self.insert.isEnabled = true
                }
                self.localization.firstName = self.name.text
                self.localization.lastName = self.lastName.text
                self.localization.mapString = self.locale.text
                self.localization.mediaURL = self.link.text
                self.performSegue(withIdentifier: "confirm", sender: nil)
            }) { [unowned self] in
                DispatchQueue.main.async {
                    self.insert.isEnabled = true
                }
                let alert = UIAlertController(title: nil, message: "Endereço não identificado.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: nil, message: "Preencha todos os campos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
