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
    
    private var todayNum: Int? = nil
    private let DEFAUL_URL = "https://cafenomad.tw/api/v1.0/cafes/"
    
    private static var instance:ServerCommunication?
    private var cafeShopItemArray = Array<CafeShopItem>()// save cafeShopItem
    
    static func shareInstance() -> ServerCommunication {
        if instance == nil {
            instance = ServerCommunication()
        }
        
        return instance!
        
    }
    
    func downLoadCafeShopData(){
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        let date = Date()
        let today = dateFormatter.string(from: date)
        todayNum = Int(today)
        
        if let yesterdayNum = UserDefaults.standard.object(forKey: YESTERDAY_USERDEFAULT_KEY) as? Int {

            print("jugment--yesterday:\(yesterdayNum)")
            
            if todayNum! > yesterdayNum {
                
                downloadCafeShopDataWithAPI()
            
            } else {
                
                downloadDataAtDocuments()
            
            }
        
        } else {
        
            print("NoUserDefault")
            downloadCafeShopDataWithAPI()
            
        }
        
    }
    
    private func downloadCafeShopDataWithAPI () {
        let url = URL(string: DEFAUL_URL)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print("error:\(error)")
                
                NotificationCenter.default.post(name: DOWNLOAD_ERROR_KEY , object: nil)
                
                return
            
            } else {
                
                do {
                    
                    let jsonObj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Array<AnyObject>
                    self.cafaShopDataProcess(jsonData: jsonObj)
                    UserDefaults.standard.set(self.todayNum, forKey: YESTERDAY_USERDEFAULT_KEY)
                    UserDefaults.standard.synchronize()
                } catch {
                    
                    NotificationCenter.default.post(name: DOWNLOAD_ERROR_KEY , object: nil)
                    print("DownLoad Error")
                }
            }
            
            }.resume()
        
    }
    
    func downloadDataAtDocuments () {
        
        let urlStr = NSHomeDirectory() + "/Documents/shopData.data"
        let dataURL = URL(fileURLWithPath: urlStr)
        let isfileExist = FileManager.default.fileExists(atPath: urlStr) // 檢查路徑
        
        if isfileExist {
            
            do {
                
                let data = try Data(contentsOf: dataURL, options: .dataReadingMapped)
                
                cafeShopItemArray = NSKeyedUnarchiver.unarchiveObject(with: data) as! Array<CafeShopItem>
                
                NotificationCenter.default.post(name: DOWNLOAD_FINISH_KEY , object: nil)
                print("doc 讀取完成")
            } catch {
                
                print("Document download fail")
                NotificationCenter.default.post(name: DOWNLOAD_ERROR_KEY , object: nil)
                
            }
            
        } else {
            
            NotificationCenter.default.post(name: DOWNLOAD_ERROR_KEY , object: nil)
            
        }
        
    }
    
    
    private func cafaShopDataProcess(jsonData:Array<AnyObject>) {
        
        for tmp in jsonData  {
            let item = CafeShopItem(tmp)
            cafeShopItemArray.append(item)
            
        }
        
        // 下載後直接將資料存進document
        
        do {
            
            let cafeShopData = NSKeyedArchiver.archivedData(withRootObject: cafeShopItemArray)
            let urlStr = NSHomeDirectory() + "/Documents/shopData.data"
            let dataURL = URL(fileURLWithPath: urlStr)
            try cafeShopData.write(to: dataURL, options: .atomic)
            
            print("存檔成功")
        } catch {
            print("存檔失敗")
        }
        print("item.counts: \(cafeShopItemArray.count)")
        
        NotificationCenter.default.post(name: DOWNLOAD_FINISH_KEY , object: nil)
        
    }
    
    // 判斷今天有沒有下載過
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
        } else {
            print("NoUserDefault")
        
            return true
        }
        
        
        
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
