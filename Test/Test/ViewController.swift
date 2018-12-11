//
//  ViewController.swift
//  Weather
//
//  Created by Dmitry Belyaev on 09/12/2018.
//  Copyright © 2018 Dmitry Belyaev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBAction func cityTappedButton(_ sender: UIBarButtonItem) {
        displayCity()
    }
    
    @IBOutlet weak var weatherImageIcon: UIImageView!
    
    
    let url = "http://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=8c031df7dbac4a3bd29b48b1aee1bb52"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let stringURL = URL(string: url)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: stringURL!) { (data, response, error) in
            do {
                let weatherJson = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                let weatherModel = WeatherModel(weatherJson: weatherJson)
                
                if error == nil {
                    print(weatherModel.cityName)
                    print(weatherModel.temperature)
                    print(weatherModel.description)
                    print(weatherModel.currentTime!)
                    print(weatherModel.icon!)
                    
                    DispatchQueue.main.async {
                        self.weatherImageIcon.image = weatherModel.icon!
                    }
                }
            }
            catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }
    
    func displayCity() {
        let alert = UIAlertController(title: "City", message: "Enter name city", preferredStyle: UIAlertController.Style.alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in
            if let textField = alert.textFields?.first {
                print(textField.text!)
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        alert.addTextField { (textField) in
            textField.placeholder = "City name"
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}


