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
import CoreLocation

protocol WeatherModelDelegate {
    func updateWeatherInfo(weatherJson : JSON)
    func failure()
}

class WeatherModel {
    let weatherUrl = "http://api.openweathermap.org/data/2.5/weather?APPID=8c031df7dbac4a3bd29b48b1aee1bb52"
    
    var delegate: WeatherModelDelegate!
    
    func getWeatherFor(geo: CLLocationCoordinate2D) {
        let params = ["lat": geo.latitude, "lon": geo.longitude]
        setRequest(params: params)
    }
    
    func getWeatherFor(city: String) {
        let params = ["q" : city]
        setRequest(params: params)
        
    }
    
    func setRequest(params: [String : Any]?) {
        Alamofire.request(weatherUrl, method: .get, parameters: params).responseJSON { (response) in
            if response.error != nil {
                self.delegate.failure()
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
        
        print(imageName)
        var iconImage = UIImage(named: imageName)
        return iconImage!
    }
    
    func convertTemperature(country: String, temperature: Double) -> Double {
        if(country == "US") {
            return ((temperature - 273.15) * 1.8 + 32)
        }
        return (temperature - 273.15)
    }

 }
