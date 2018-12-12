//
//  WeatherModel.swift
//  Weather
//
//  Created by Dmitry Belyaev on 09/12/2018.
//  Copyright © 2018 Dmitry Belyaev. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

protocol WeatherModelDelegate {
    func updateWeatherInfo(weatherJson : JSON)
}

class WeatherModel {
    let weatherUrl = "http://api.openweathermap.org/data/2.5/weather?APPID=8c031df7dbac4a3bd29b48b1aee1bb52"
    
    var delegate: WeatherModelDelegate!
    
    func getWeatherFor(city: String) {
        let params = ["q" : city]
        setRequest(params: params)
        
    }
    
    func setRequest(params: [String : Any]?) {
        Alamofire.request(weatherUrl, method: .get, parameters: params).responseJSON { (response) in
            if response.error != nil {
                NSLog("Error: \(response.error)")
            } else {
                let json = response.result.value
                print(json!)
                let weatherJson = JSON(json!)
                
                DispatchQueue.main.async {
                    self.delegate.updateWeatherInfo(weatherJson: weatherJson)
                }
            }
        }
    }
    
    func getTime(timeMilliseconds: Int) -> String {
        let interval = TimeInterval(timeMilliseconds)
        let weatherDate = Date(timeIntervalSince1970: interval)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: weatherDate)
    }
    
    func updateWeatherIcon(condition: Int, nightTime: Bool) -> UIImage {
        var imageName: String
        switch(condition, nightTime) {
            case let(x,y) where x < 300 && y == true: imageName = "11n"
            case let(x,y) where x < 300 && y == false: imageName = "11d"
            
            case let(x,y) where x < 500 && y == true: imageName = "09n"
            case let(x,y) where x < 500 && y == false: imageName = "09d"
            
            case let(x,y) where x <= 504 && y == true: imageName = "10n"
            case let(x,y) where x <= 504 && y == false: imageName = "10d"
            
            case let(x,y) where x <= 511 && y == true: imageName = "13n"
            case let(x,y) where x <= 511 && y == false: imageName = "13d"
            
            case let(x,y) where x < 600 && y == true: imageName = "09n"
            case let(x,y) where x < 600 && y == false: imageName = "09d"
            
            case let(x,y) where x < 700 && y == true: imageName = "13n"
            case let(x,y) where x < 700 && y == false: imageName = "13d"
            
            case let(x,y) where x < 800 && y == true: imageName = "50n"
            case let(x,y) where x < 800 && y == false: imageName = "50d"
            
            case let(x,y) where x == 800 && y == true: imageName = "01n"
            case let(x,y) where x == 800 && y == false: imageName = "01d"
            
            case let(x,y) where x == 801 && y == true: imageName = "02n"
            case let(x,y) where x == 801 && y == false: imageName = "02d"
            
            case let(x,y) where x > 802 || x < 804 && y == true: imageName = "03n"
            case let(x,y) where x > 802 || x < 804 && y == false: imageName = "03d"
            
            case let(x,y) where x == 804 && y == true: imageName = "04n"
            case let(x,y) where x == 804 && y == false: imageName = "04d"
            
            case let(x,y) where x < 1000 && y == true: imageName = "11n"
            case let(x,y) where x < 1000 && y == false: imageName = "11d"
            
            case let(x,y): imageName = "none"
        }
        
        var iconImage = UIImage(named: imageName)
        return iconImage!
    }
    
    func getIcon(stringIcon: String) -> UIImage {
        
        let imageName: String
        switch stringIcon {
        case "01d": imageName = "01d"
        case "02d": imageName = "02d"
        case "03d": imageName = "03d"
        case "04d": imageName = "04d"
        case "09d": imageName = "09d"
        case "10d": imageName = "10d"
        case "11d": imageName = "11d"
        case "13d": imageName = "13d"
        case "50d": imageName = "50d"
        case "01n": imageName = "01n"
        case "02n": imageName = "02n"
        case "03n": imageName = "03n"
        case "04n": imageName = "04n"
        case "09n": imageName = "09n"
        case "10n": imageName = "10n"
        case "11n": imageName = "11n"
        case "13n": imageName = "13n"
        case "50n": imageName = "50n"
        default: imageName = "none"
        }
        
        var iconImage = UIImage(named: imageName)
        return iconImage!
    }
    
    func convertTemperature(country: String, temperature: Double) -> Double {
        if(country == "US") {
            return round((temperature - 273.15) * 1.8 + 32)
        }
        return round(temperature - 273.15)
    }
}
