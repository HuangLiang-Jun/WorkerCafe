//
//  ServerComunication.swift
//  WorkerCafe
//
//  Created by huang on 2016/12/21.
//  Copyright © 2016年 Huang. All rights reserved.
//

import Foundation
import CoreLocation

class ServerCommunication:NSObject,CLLocationManagerDelegate
{
    private let DEFAUL_URL = "https://cafenomad.tw/api/v1.0/cafes/"
    
    private static var instance:ServerCommunication?
    
    
    static func shareInstance() -> ServerCommunication {
        if instance == nil {
            instance = ServerCommunication()
        }
        
        return instance!
        
    }
    
    func downLoadCafeShopData(){
        
        // 準備用來做離線下載使用
        if jugmentLastTimeDownloadDate() {
            
            print("go download ")
        } else {
            print("get userdefault data")
        }
        
        let url = URL(string: DEFAUL_URL)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("error:\(error)")
                
            } else {
                
                do {
                    
                    let jsonObj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Array<AnyObject>
                    self.cafaShopDataProcess(jsonData: jsonObj)
                    
                } catch {
                    print("DownLoad Error")
                }
            }
            
            }.resume()
    }
    
    var cafeShopItemArray = Array<CafeShopItem>()// save cafeShopItem
    
    func cafaShopDataProcess(jsonData:Array<AnyObject>) {
        
        
        for tmp in jsonData  {
            let item = CafeShopItem()
            if let name = tmp["name"] {
                item.name = name as! String
            }
            if let city = tmp["city"] {
                item.city = city as! String
            }
            if let address = tmp["address"] {
                item.address = address as! String
            }
            if let urlString = tmp["url"] {
                item.urlStr = urlString as! String
            }
            if let lat = tmp["latitude"] {
                item.lat = Double(lat as! String)
            }
            if let lon = tmp["longitude"] {
                item.lon = Double(lon as! String)
            }
            if let wifi = tmp["wifi"] {
                item.wifi = String(wifi as! Double)
            }
            if let seat = tmp["seat"] {
                item.seat = String(seat as! Double)
            }
            if let music = tmp["music"] {
                
                item.music = String(music as! Double)
            }
            if let quiet = tmp["quiet"] {
                item.quiet = String(quiet as! Double)
            }
            if let cheap = tmp["cheap"] {
                item.cheap = String(cheap as! Double)
            }
            if let tasty = tmp["tasty"] {
                item.tasty = String(tasty as! Double)
            }
            cafeShopItemArray.append(item)
            
        }
        print("item.counts: \(cafeShopItemArray.count)")
        
        /*
         把解析完的自定義類別array存進document
        */
        
        NotificationCenter.default.post(name: DOWNLOAD_FINISH_KEY , object: nil)
        
    }
    
    /*
    //                                                                      //
    //  If interval a day of time ,return true and download data at net,    //
    //  else return false and download data at document.                    //
    //                                                                      //
    */
    private func jugmentLastTimeDownloadDate() -> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        let date = Date()
        let today = dateFormatter.string(from: date)
        let todayNum = Int(today)
        
        if let yesterdayNum = UserDefaults.standard.object(forKey: YESTERDAY_USERDEFAULT_KEY) as? Int {
            print("jugment")
            UserDefaults.standard.set(todayNum, forKey: YESTERDAY_USERDEFAULT_KEY)
            UserDefaults.standard.synchronize()
            print("yesterday:\(yesterdayNum)")
            if todayNum! > yesterdayNum {
                
                return true
            } else {
                
                return false
            }
        }
        
        UserDefaults.standard.set(todayNum, forKey: YESTERDAY_USERDEFAULT_KEY)
        UserDefaults.standard.synchronize()
        print("noYesterdat")
        return true
    }
    
    
    func getCafeShopInfo() -> Array<Any> {
       
        return cafeShopItemArray
    }
    
    func startToSearchingCafeShop(_ conditions:Array<String>) -> Array<Any>? {
        
        var resultArr = Array<CafeShopItem>()
        let placeTmp = placesDict[conditions[0]]!
        print("placeTMP:\(placeTmp)")
        for item in cafeShopItemArray {
           
            if item.city! == placeTmp || placeTmp == ""{
                
                if Double(item.wifi)! >= Double(conditions[1])! {
                    
                    if Double(item.seat)! >= Double(conditions[2])! {
                        
                        if Double(item.quiet)! >= Double(conditions[3])! {
                            
                            if Double(item.tasty)! >= Double(conditions[4])! {
                                
                                resultArr.append(item)
                            }
                        }
                    }
                }
            }
        }
       
        print("resultData:\(resultArr)")
        return resultArr
    }
}
