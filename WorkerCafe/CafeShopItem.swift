//
//  CafeShopItem.swift
//  WorkerCafe
//
//  Created by huang on 2017/1/12.
//  Copyright © 2017年 Huang. All rights reserved.
//

import Foundation
import CoreLocation

class CafeShopItem:NSObject, CLLocationManagerDelegate {
    
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
    
}
