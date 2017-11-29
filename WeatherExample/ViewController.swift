//
//  ViewController.swift
//  WeatherExample
//
//  Created by Metin Ağaoğlu on 18.10.2017.
//  Copyright © 2017 Metin Ağaoğlu. All rights reserved.
//

import UIKit
import Kingfisher
import CoreLocation

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {

   
    var weatherList = [WeatherData]()
    
    // Location Manager
    var locationManager = CLLocationManager()
    
    // Storyboard Views
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
       
    }
    
    // Location Result
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
            getRequest(lat: locations[0].coordinate.latitude,long: locations[0].coordinate.longitude)
        }
        
        
    }

    // TableView Func
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherTableViewCell
        cell.descriptionText.text = weatherList[indexPath.row].description
        cell.timeText.text = weatherList[indexPath.row].dt_txt
        cell.iconView.kf.setImage(with: URL(string: weatherList[indexPath.row].iconURL ))
        return cell
    }

    // Get Request
    func getRequest(lat:Double,long:Double){
        
        let langCode:String
        let lang = Locale.current.languageCode
        
        langCode = lang as! String

        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(long)&appid=0bc0a3423e91f20c18d183efbde496e8&lang=\(langCode)")
        
        //print(url)
        
        let myData = try! Data(contentsOf: url!)
        let jsonDecoder = JSONDecoder()
    
        let results = try? jsonDecoder.decode(WeatherModel.self, from: myData)
        
        self.infoText.text = results?.list.first?.weather[0].description
        self.locationText.text = results?.city.name
        
        let firstIconURL = imagePath(icon: (results?.list.first?.weather[0].icon)!)
        self.iconImageView.kf.setImage(with: URL(string:firstIconURL))
        
        for item in (results?.list)! {
            
            let wData = WeatherData()
            wData.description = item.weather[0].description
            wData.iconURL = imagePath(icon: item.weather[0].icon)
            wData.dt_txt = String(item.dt_txt)
            
           self.weatherList.append(wData)
         
        }
        
        self.tableView.reloadData()
        
    }
    
    func imagePath(icon:String)->String {
        let path = "http://openweathermap.org/img/w/"+icon+".png"
        return path
    }

}

