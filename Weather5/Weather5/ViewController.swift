//
//  ViewController.swift
//  Weather
//
//  Created by Dmitry Belyaev on 09/12/2018.
//  Copyright © 2018 Dmitry Belyaev. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, WeatherModelDelegate {
    
    var weatherModel = WeatherModel()
    
    @IBAction func cityTappedButton(_ sender: UIBarButtonItem) {
        displayCity()
    }
    
    @IBOutlet weak var weatherImageIcon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherModel.delegate = self
    }
    
    func displayCity() {
        let alert = UIAlertController(title: "City", message: "Enter name city", preferredStyle: UIAlertController.Style.alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in
            if let textField = alert.textFields?.first {
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
    
    func updateWeatherInfo(weatherJson: JSON) {
        
        if let temperatureResult = weatherJson["main"]["temp"].double {
            let country = weatherJson["sys"]["country"].string
            let temperature = weatherModel.convertTemperature(country: country!, temperature: temperatureResult)
            print(country)
            print(temperature)
            
        } else {
            print("Unable to load weather info")
        }
    }
    
}


