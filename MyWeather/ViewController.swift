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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let font = UIFont(name: "AppleSDGothicNeo-Light", size: 32.0)
        weatherDisplay.font = font
        cityDisplay.font = font
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
                let weatherData = parseJson(data)
                println(weatherData)
                let city = weatherData["name"] as String
                let temp = String(format:"%.1f", weatherData["main"]!["temp"] as Double)
                NSLog(city)
                NSLog(temp)
                dispatch_async(dispatch_get_main_queue()) {
                    self.cityDisplay.text = city
                    self.weatherDisplay.text = temp
                    self.activityIndicator.hidden = true
                }
            } else {
                NSLog("Error occurred")
                println(error)
                println(response)
            }
            
            }.resume()
    }
    
}

func parseJson(jsonData: NSData) -> NSDictionary {
    var error: NSError?
    let jsonDict = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as NSDictionary
    if (error == nil) {
        return jsonDict
    } else {
        return NSDictionary()
    }
}

