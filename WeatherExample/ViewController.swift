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

   
    var weatherList = [WeatherModel]()
    
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

        getRequest(lat: locations[0].coordinate.latitude,long: locations[0].coordinate.longitude)
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
        
        langCode = lang as String
        
        let _url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(long)&appid=(appid)&lang=\(langCode)")
        
        let task = URLSession.shared.dataTask(with: _url!) { (data, response, error) in
            
            if error == nil{
               
                do{
                     let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String,AnyObject>
                    
                    
                    DispatchQueue.main.async {
                    
                        var counter:Int = 0;
                        
                        var _locationInfoServer = ""
                        let name = jsonResult["city"]!["name"] as! String
                        let country = jsonResult["city"]!["country"] as! String
                        _locationInfoServer = "\(name),\(country)"
                        
                        for item in jsonResult["list"]  as! [Dictionary<String, AnyObject>]
                        {
                     
                            var parentDesc = "";
                            var iconUrl = "";
                            
                            for wItem in item["weather"] as! [Dictionary<String, AnyObject>] {
                                parentDesc = wItem["description"] as! String
                                iconUrl = "http://openweathermap.org/img/w/"+(wItem["icon"]! as! String)+".png"
                            }
                            
                            if counter == 0{
                                self.infoText.text = parentDesc
                                self.locationText.text = _locationInfoServer
                                self.iconImageView.kf.setImage(with: URL(string: iconUrl))
                            }
                            
                            counter += 1;
                            
                            let desc:String = parentDesc
                            let date:String = item["dt_txt"] as! String
                            
                            let weatherM = WeatherModel()
                            weatherM.description = desc
                            weatherM.dt_txt = date
                            weatherM.iconURL = iconUrl
                            self.weatherList.append(weatherM)
                        }
                        
                        self.tableView.reloadData()
                    }
                }catch{
                    print("hata")
                }
            }
            
        }
        
        task.resume()
        
    }

}

