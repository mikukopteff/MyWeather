//
//  ViewController.swift
//  MyWeather
//
//  Created by Mikael Kopteff on 23/01/15.
//  Copyright (c) 2015 Mikael Kopteff. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var weatherDisplay: UILabel!
    
    @IBOutlet weak var cityDisplay: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var descriptionDisplay: UILabel!
    
    @IBOutlet weak var windDirectionDisplay: UILabel!
    
    @IBOutlet weak var windSpeedDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_small.jpg")!)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "foreGroundNotification:", name:"WillEnterForeground", object: nil)
        loadDataForUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func foreGroundNotification(notification: NSNotification) {
        self.activityIndicator.hidden = false
        loadDataForUI()
    }
    
    func loadDataForUI() {
        NSLog("Updating data!")
        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=Helsinki,fi&units=metric")
        NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if (error == nil) {
                if let weatherData = parseJson(data) {
                    let weather = mapWeatherDataToStruct(weatherData)
                    self.addWeatherToUI(weather)
                }
            } else {
                NSLog("Error occurred")
                println(error)
                println(response)
            }
            
            }.resume()
    }
    
    func addWeatherToUI(weather: Weather) {
        dispatch_async(dispatch_get_main_queue()) {
            self.cityDisplay.text = weather.city
            self.weatherDisplay.text = weather.temp + "°C"
            self.activityIndicator.hidden = true
            self.descriptionDisplay.text = weather.description.capitalizedString
            self.windDirectionDisplay.text = weather.windDirection + "°"
            self.windSpeedDisplay.text = weather.windSpeed + " m/s"
        }
        
    }
    
}

func mapWeatherDataToStruct (weatherData: NSDictionary) -> Weather {
    let city = weatherData["name"] as String
    let temp = String(format:"%.1f", weatherData["main"]!["temp"] as Double)
    let desc = weatherData["weather"]![0]["description"]! as String
    let windDir = String(format:"%.1f", weatherData["wind"]!["deg"] as Double)
    let windSpeed = String(format:"%.1f", weatherData["wind"]!["speed"] as Double)
    NSLog(city)
    NSLog(temp)
    NSLog(desc)
    NSLog(windDir)
    NSLog(windSpeed)
    return  Weather(city: city,temp: temp, description: desc, windDirection: windDir, windSpeed: windSpeed)
}

func parseJson(jsonData: NSData) -> NSDictionary? {
    var error: NSError?
    let jsonDict = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as NSDictionary
    if (error == nil) {
        println(jsonDict)
        return jsonDict
    } else {
        return nil
    }
}
struct Weather {
    let city: String
    let temp: String
    let description: String
    let windDirection: String
    let windSpeed: String
    init(city: String, temp: String, description: String, windDirection: String, windSpeed: String) {
        self.city = city
        self.temp = temp
        self.description = description
        self.windDirection = windDirection
        self.windSpeed = windSpeed
    }
}

