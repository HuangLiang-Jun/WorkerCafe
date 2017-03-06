//
//  CafeShopItem.swift
//  WorkerCafe
//
//  Created by huang on 2017/1/12.
//  Copyright © 2017年 Huang. All rights reserved.
//

import Foundation


class CafeShopItem:NSObject, NSCoding {
    
    var city: String!
    var name: String!
    var address: String!
    var urlStr: String!
    var lat: Double!
    var lon: Double!
    var wifi: String!
    var seat: String!
    var music: String!
    var quiet: String!
    var cheap: String!
    var tasty: String!
    
    init(_ item: AnyObject) {
        if let name = item["name"] {
            self.name = name as! String
        }
        if let city = item["city"] {
            self.city = city as! String
        }
        if let address = item["address"] {
            self.address = address as! String
        }
        if let urlString = item["url"] {
            self.urlStr = urlString as! String
        }
        if let lat = item["latitude"] {
            self.lat = Double(lat as! String)
        }
        if let lon = item["longitude"] {
            self.lon = Double(lon as! String)
        }
        if let wifi = item["wifi"] {
            self.wifi = String(wifi as! Double)
        }
        if let seat = item["seat"] {
            self.seat = String(seat as! Double)
        }
        if let music = item["music"] {
            
            self.music = String(music as! Double)
        }
        if let quiet = item["quiet"] {
            self.quiet = String(quiet as! Double)
        }
        if let cheap = item["cheap"] {
            self.cheap = String(cheap as! Double)
        }
        if let tasty = item["tasty"] {
            self.tasty = String(tasty as! Double)
        }
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(name, forKey: "name")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(urlStr, forKey: "urlStr")
        aCoder.encode(lat, forKey: "lat")
        aCoder.encode(lon, forKey: "lon")
        aCoder.encode(wifi, forKey: "wifi")
        aCoder.encode(seat, forKey: "seat")
        aCoder.encode(music, forKey: "music")
        aCoder.encode(quiet, forKey: "quiet")
        aCoder.encode(cheap, forKey: "cheap")
        aCoder.encode(tasty, forKey: "tasty")
        
    }

    required init?(coder aDecoder: NSCoder) {
        
        name = aDecoder.decodeObject(forKey: "name") as? String
        city = aDecoder.decodeObject(forKey: "city") as? String
        address = aDecoder.decodeObject(forKey: "address") as? String
        urlStr = aDecoder.decodeObject(forKey: "urlStr") as? String
        lat = aDecoder.decodeObject(forKey: "lat") as? Double
        lon = aDecoder.decodeObject(forKey: "lon") as? Double
        wifi = aDecoder.decodeObject(forKey: "wifi") as? String
        seat = aDecoder.decodeObject(forKey: "seat") as? String
        music = aDecoder.decodeObject(forKey: "music") as? String
        quiet = aDecoder.decodeObject(forKey: "quiet") as? String
        cheap = aDecoder.decodeObject(forKey: "cheap") as? String
        tasty = aDecoder.decodeObject(forKey: "tasty") as? String
        
    }
    

    
}
