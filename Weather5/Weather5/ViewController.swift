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
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    
    @IBOutlet weak var weatherSearchBar: UISearchBar!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImageIcon: UIImageView!
    var weatherModel = WeatherModel()
    var hud = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "gradient.jpg")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        weatherSearchBar.delegate = self
        self.weatherModel.delegate = self
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
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
            self.cityLabel.text = "\(cityName!), \(country!)"
            
            let temperature = weatherModel.convertTemperature(country: country!, temperature: temperatureResult)
            self.temperatureLabel.text = String(format: "%.1f", temperature)
            
            let weather = weatherJson["weather"][0]
            let icon = weatherModel.getIcon(stringIcon: weather["icon"].string!)
            self.weatherImageIcon.image = icon
        
            let humidity = weatherJson["main"]["humidity"].intValue
            self.humidityLabel.text = "humidity: \(humidity)"
            
            let description = weather["description"].stringValue
            self.descriptionLabel.text = "description: \(description)"
            
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
        
        self.activityIndicator()
        var currentLocation = locations.last as! CLLocation
        
        if(currentLocation.horizontalAccuracy > 0) {
             locationManager.stopUpdatingLocation()
            
            let coords = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            
            self.weatherModel.getWeatherFor(geo: coords)
        }
        
       
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print("Can't get your location!")
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.activityIndicator()
        self.weatherModel.getWeatherFor(city: searchBar.text!)
        view.endEditing(true)
    }
}


