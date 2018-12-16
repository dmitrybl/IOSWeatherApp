//
//  ViewController.swift
//  Weather
//
//  Created by Dmitry Belyaev on 09/12/2018.
//  Copyright © 2018 Dmitry Belyaev. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, WeatherModelDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var temperatureLabel: UITextView!
    @IBOutlet weak var cityLabel: UITextView!
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    
    var weatherModel = WeatherModel()
    var hud = MBProgressHUD()
    
    @IBAction func cityTappedButton(_ sender: UIBarButtonItem) {
        displayCity()
    }
    
    @IBOutlet weak var weatherImageIcon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherModel.delegate = self
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    
    func displayCity() {
        let alert = UIAlertController(title: "City", message: "Enter name city", preferredStyle: UIAlertController.Style.alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in
            if let textField = alert.textFields?.first {
                self.activityIndicator()
                self.weatherModel.getWeatherFor(city: textField.text!)
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        alert.addTextField { (textField) in
            textField.placeholder = "City name"
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func activityIndicator() {
        hud.label.text = "Loading..."
        self.view.addSubview(hud)
        hud.show(animated: true)
    }
    
    func updateWeatherInfo(weatherJson: JSON) {
        
        hud.hide(animated: true)
        
        if let temperatureResult = weatherJson["main"]["temp"].double {
            
            let country = weatherJson["sys"]["country"].string
            
            let cityName = weatherJson["name"].string
            
            let temperature = weatherModel.convertTemperature(country: country!, temperature: temperatureResult)
            
            let weather = weatherJson["weather"][0]
            let icon = weatherModel.getIcon(stringIcon: weather["icon"].string!)
            self.weatherImageIcon.image = icon
            cityLabel.text = "\(cityName!)(\(country!))"
            temperatureLabel.text = String(format: "%.1f", temperature)
            
        } else {
            print("Unable to load weather info")
        }
    }
    
    func failure() {
        let networkController = UIAlertController(title: "Error", message: "No connection!", preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,
                                     handler: nil)
        networkController.addAction(okButton)
        self.present(networkController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location)
        
        self.activityIndicator()
        var currentLocation = locations.last as! CLLocation
        
        if(currentLocation.horizontalAccuracy > 0) {
             locationManager.stopUpdatingLocation()
            
            let coords = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            
            self.weatherModel.getWeatherFor(geo: coords)
            print(coords)
        }
        
       
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print("Can't get your location!")
    }
    
}


