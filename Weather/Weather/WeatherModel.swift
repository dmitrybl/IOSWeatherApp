//
//  WeatherModel.swift
//  Weather
//
//  Created by Dmitry Belyaev on 09/12/2018.
//  Copyright © 2018 Dmitry Belyaev. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class WeatherModel {
    var cityName: String
    var temperature: NSNumber
    var description: String
    var currentTime: String?
    var icon: UIImage?
    
    init(weatherJson: NSDictionary) {
        cityName = weatherJson["name"] as! String
        let main = weatherJson["main"] as! NSDictionary
        temperature = main["temp"] as! NSNumber
        
        let weather = weatherJson["weather"] as! NSArray
        let d = weather[0] as! NSDictionary
        description = d["description"] as! String
        
        let dt = weatherJson["dt"] as! Int
        currentTime = getTime(timeMilliseconds: dt)
        
        let strIcon = d["icon"] as! String
        icon = getIcon(stringIcon: strIcon)
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
        
        var iconImage = UIImage(named: imageName)
        return iconImage!
    }
}
