//
//  WeatherModel.swift
//  WeatherExample
//
//  Created by Metin Ağaoğlu on 26.11.2017.
//  Copyright © 2017 Metin Ağaoğlu. All rights reserved.
//

import Foundation

struct WeatherModel:Codable {
    
    var cod:String
    var message:Double
    var list:[listEntity]
    var city:city
    
    struct listEntity:Codable {
        var dt:Int
        var dt_txt:String
        var weather:[Weather]
        var wind:wind
        
        
        struct Weather:Codable {
            var description:String
            var icon:String
            var main:String
        }
        
        struct wind:Codable {
            var speed:Float
        }
    }
    
    struct city:Codable {
        var name:String
    }
    
}
