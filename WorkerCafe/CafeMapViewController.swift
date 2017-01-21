//
//  CafeMapViewController.swift
//  WorkerCafe
//
//  Created by huang on 2016/12/21.
//  Copyright © 2016年 Huang. All rights reserved.
//

import UIKit
import CoreLocation
class CafeMapViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let mapView = GoogleMapViewModel()
    let comm = ServerCommunication.shareInstance()
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var storeName_Label: UILabel!
    @IBOutlet weak var wifi_Label: UILabel!
    @IBOutlet weak var seat_Label: UILabel!
    @IBOutlet weak var quiet_Label: UILabel!
    @IBOutlet weak var cheap_Label: UILabel!
    @IBOutlet weak var tasty_Label: UILabel!
    @IBOutlet weak var music_Label: UILabel!
    
    var userConditionsArr = ["全國", "0", "0", "0", "0"]
    var slideMenu:SlideMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector:#selector(startToSetupMapView) , name:DOWNLOAD_FINISH_KEY , object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(removeAlertView(notifcationInfo:)) , name: REMOVE_KEY_NAME, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(showDetailView) , name:SHOW_DETAIL_VIEW_NAME , object: nil)
        
        detailView.frame.origin.y = self.view.frame.height
    }
    

    
    // MARK: locationManagerDelegate
    let locationManager = CLLocationManager()
    var getUserLocation = true
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if getUserLocation {
            getUserLocation = false
            let myLocation = locations.last!
            locationManager.stopUpdatingLocation()
            self.view.addSubview(mapView.setup(userLocation: myLocation))
            
            slideMenu = SlideMenu()
            slideMenu.searchBtn.addTarget(self, action: #selector(searchBtnPressed), for: .touchDown)
            slideMenu.menuTableView.delegate = self
            slideMenu.menuTableView.dataSource = self
            self.view.addSubview(slideMenu)
            let infoArr = comm.getCafeShopInfo()
            mapView.addCoffeeShopLocation(info: infoArr)
            
        }
    }
    
    // MARK: SlideMenuSearchBtn
    func searchBtnPressed() {
        print("startSearching")
        slideMenu.callMenu()
        
        guard let infoArr = comm.startToSearchingCafeShop(userConditionsArr) else {
         
            print("解析失敗")
            return
        }

        if infoArr.count == 0 {
            print("無相關條件資料")
            return
        }
        mapView.resetCafeshopMaekers(info: infoArr)
        print("searchResult:\(infoArr)")
        
    }
    // callMenuBtn
    @IBAction func callMenuBtnPressed(_ sender: UIBarButtonItem) {
        
        slideMenu.callMenu()
        if detailView.frame.origin.y != self.view.frame.height {
            
            UIView.animate(withDuration: TimeInterval(menuSwichPageScale)) {
                
                self.detailView.frame.origin.y = self.view.frame.height
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: tableViewDelegate & DataSource function

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return conditionsList.count
    }
    
    var locationCell = LocationCell()
    var otherCell = SearchMenuCell()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        // return different xib cell
        if indexPath.row == 0 {
            locationCell = slideMenu.menuTableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            locationCell.titleLabel.text = conditionsList[indexPath.row]
            locationCell.locationLabel.text = userConditionsArr[indexPath.row]
            return locationCell
            
        } else {
            
            otherCell = slideMenu.menuTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchMenuCell
            otherCell.titleLabel.text = conditionsList[indexPath.row]
            otherCell.pointLabel.text = userConditionsArr[indexPath.row]
            return otherCell
        }
    }
    
    var alert:CustomSearchAlertView! // When user clicked options in menu will show this view to choose scores
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        slideMenu.menuTableView.deselectRow(at: indexPath, animated: true)
        //let selectedOption = conditionsList[indexPath.row]
        
        // options Alert
        alert = CustomSearchAlertView()
        alert.setup(indexPath: indexPath.row)
        self.navigationController?.view.addSubview(alert)
        
    }
    
    func startToSetupMapView() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
 
    }
    
    // 接到notification通知後 接收使用者搜尋的條件 並修改userConditionArr的內容
    func removeAlertView(notifcationInfo: Notification) {
        
        if let object = notifcationInfo.object as? Array<Any> {
            print("object:\(object)")
            print("1: \(object.first!)")
            print("2: \(object.last!)")
            let changeIndex = object.first as! Int
            let option = object.last as! String
            userConditionsArr[changeIndex] = option
            
            print("arr:\(userConditionsArr)")
        }
        slideMenu.menuTableView.reloadData()
        alert.removeFromSuperview()
    }
    
    // MARK: DV function
    private let menuSwichPageScale: Float = 0.25
    var urlStr:String?
    var selectedCoordinate:CLLocationCoordinate2D?
    
    func showDetailView(notifcationInfo: Notification) {
        
        if slideMenu.frame.origin.x == 0 {
            slideMenu.callMenu()
        }
        
        if let status = notifcationInfo.object as? Bool {
            
            if status  {
                print("點擊大頭針，顯示DV")
                
                if let info = notifcationInfo.userInfo?["item"] as? CafeShopItem {
                 
                    storeName_Label.text = info.name
                    wifi_Label.text = info.wifi
                    seat_Label.text = info.seat
                    quiet_Label.text = info.quiet
                    cheap_Label.text = info.cheap
                    tasty_Label.text = info.tasty
                    music_Label.text = info.music
                    urlStr = info.urlStr ?? "沒提供網址"
                    selectedCoordinate?.latitude = info.lat
                    selectedCoordinate?.longitude = info.lon
                    print("info:\(info.name )")
                    
                }
                if detailView.frame.origin.y != self.view.frame.height - self.detailView.frame.height {
                    
                    UIView.animate(withDuration: TimeInterval(menuSwichPageScale)) {
                        
                        self.detailView.frame.origin.y = self.view.frame.height - self.detailView.frame.height
                        self.view.insertSubview(self.detailView, aboveSubview: self.view)
                    }
                }
            
            } else {
                print("點擊地圖，收DV")
                UIView.animate(withDuration: TimeInterval(menuSwichPageScale)) {
                    
                    self.detailView.frame.origin.y = self.view.frame.height
                }
            }
        }
    }
    
    // DV BTN
    @IBAction func officialWebsiteBtnPressed(_ sender: UIButton) {
        print("Go Offical Website")
    }
    
    @IBAction func navigationBtnPressed(_ sender: UIButton) {
        print("take me to there")
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
