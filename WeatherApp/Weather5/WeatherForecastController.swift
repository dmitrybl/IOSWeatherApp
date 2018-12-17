//
//  WeatherForecastController.swift
//  Weather5
//
//  Created by Dmitry Belyaev on 17/12/2018.
//  Copyright © 2018 Dmitry Belyaev. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class WeatherForecastController: UIViewController, WeatherModelDelegate {
    
    var cityName: String? = nil

    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    @IBOutlet var imageView4: UIImageView!
    @IBOutlet var imageView5: UIImageView!
    @IBOutlet var imageView6: UIImageView!
    @IBOutlet var imageView7: UIImageView!
    
    
    @IBOutlet var textView1: UILabel!
    @IBOutlet var textView2: UILabel!
    @IBOutlet var textView3: UILabel!
    @IBOutlet var textView4: UILabel!
    @IBOutlet var textView5: UILabel!
    @IBOutlet var textView6: UILabel!
    @IBOutlet var textView7: UILabel!
    
    var images : [UIImageView?] = []
    var labels : [UILabel?] = []
    
    var weatherModel = WeatherModel()
    var hud = MBProgressHUD()
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images.append(imageView1)
        images.append(imageView2)
        images.append(imageView3)
        images.append(imageView4)
        images.append(imageView5)
        images.append(imageView6)
        images.append(imageView7)
        
        labels.append(textView1)
        labels.append(textView2)
        labels.append(textView3)
        labels.append(textView4)
        labels.append(textView5)
        labels.append(textView6)
        labels.append(textView7)
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "gradient.jpg")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        self.weatherModel.delegate = self
        if(cityName != nil) {
            cityLabel.text = cityName!
            self.weatherModel.getForecastFor(city: cityName!)
        }
    }
    
    func updateWeatherInfo(weatherJson: JSON) {
        hideProgress()
        for i in 0...6 {
            if let temperatureResult = weatherJson["list"][i]["main"]["temp"].double {
                let temperature = weatherModel.convertTemperature(temperature: temperatureResult)
                let dateTime = weatherJson["list"][i]["dt_txt"].string
                labels[i]?.text = "\(temperature) \(dateTime!)"
                
                let icon = weatherModel.getIcon(stringIcon: weatherJson["list"][i]["weather"][0]["icon"].string!)
                images[i]?.image = icon
            }
          
        }
    }
    
    func activityIndicator() {
        hud.label.text = "Loading..."
        self.view.addSubview(hud)
        hud.show(animated: true)
    }
    
    func showAlertDialog(title: String, message: String) {}
    
    func hideProgress() {
        hud.hide(animated: true)
    }
    

}
