//
//  CafeMapViewController.swift
//  WorkerCafe
//
//  Created by huang on 2016/12/21.
//  Copyright © 2016年 Huang. All rights reserved.
//

import UIKit
import MapKit
import SVProgressHUD
import MessageUI
import CoreLocation


class CafeMapViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    let mapView = GoogleMapViewModel()
    let comm = ServerCommunication.shareInstance()
    
    @IBOutlet weak var officialBtn: UIButton!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var appInformationView: UIView!
    @IBOutlet weak var infoSubView: UIView!
    
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
        
        NotificationCenter.default.addObserver(self, selector:#selector(downloadError) , name:DOWNLOAD_ERROR_KEY , object: nil)
        appInformationView.frame = CGRect(x: self.view.frame.width,
                                          y: 0,
                                          width: self.view.frame.width,
                                          height: self.view.frame.height)
        
        infoSubView.center = appInformationView.center
        // startLoadingView
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        
        comm.downLoadCafeShopData()
        print("done")
        detailView.frame.origin.y = self.view.frame.height
        detailView.frame.size.width = self.view.frame.width
        detailView.backgroundColor = UIColor(red:1.00, green:0.86, blue:0.73, alpha:1.0)
    }
    
    // set up
    func startToSetupMapView() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
    // MARK: locationManagerDelegate
    let locationManager = CLLocationManager()
    var getUserLocation = true
    var myLocation = CLLocation()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if getUserLocation {
            getUserLocation = false
            myLocation = locations.last!
            locationManager.stopUpdatingLocation()
            self.view.addSubview(mapView.setup(userLocation: myLocation))
            
            slideMenu = SlideMenu()
            slideMenu.searchBtn.addTarget(self, action: #selector(searchBtnPressed), for: .touchDown)
            slideMenu.defaultBtn.addTarget(self, action: #selector(defaultBtnPressed), for: .touchUpInside)
            slideMenu.menuTableView.delegate = self
            slideMenu.menuTableView.dataSource = self
            self.view.addSubview(slideMenu)
            let infoArr = comm.getCafeShopInfo()
            mapView.addCoffeeShopLocation(info: infoArr)
            // MARK: dismissLoadingView
            SVProgressHUD.dismiss()
        }
    }
    
    // MARK: SlideMenuBtn
    func searchBtnPressed() {
        print("startSearching")
        slideMenu.callMenu()
        
        guard let infoArr = comm.startToSearchingCafeShop(userConditionsArr) else {
        
            print("解析失敗")
            return
        }

        if infoArr.count == 0 {
            let alert = UIAlertController.init(title: "哦!", message: "沒有符合的店家哦!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("無相關條件資料")
            return
        }
        mapView.resetCafeshopMaekers(info: infoArr)
        print("searchResult:\(infoArr)")
        
    }
    
    func defaultBtnPressed() {
        
        userConditionsArr = ["全國", "0", "0", "0", "0"]
        slideMenu.menuTableView.reloadData()
        print("DefaultSetting:\(userConditionsArr)")
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
    
    // MARK: APP Information Btn
    @IBAction func callAppInformationBtnPressed(_ sender: UIBarButtonItem) {
        
        if slideMenu.frame.origin.x == 0 {
            slideMenu.callMenu()
        }
        
        if appInformationView.frame.origin.x != 0 {
           
            UIView.animate(withDuration: TimeInterval(menuSwichPageScale)) {
                self.view.insertSubview(self.appInformationView, aboveSubview: self.view)
                self.appInformationView.frame.origin.x = 0
                self.infoSubView.center = self.appInformationView.center
            }
        } else {
            
            UIView.animate(withDuration: TimeInterval(menuSwichPageScale), animations: {
                self.appInformationView.frame.origin.x = self.view.frame.width
                self.infoSubView.center = self.appInformationView.center
            })
        }
    }
    
    @IBAction func designerMailBtnPressed(_ sender: UIButton) {
        sendMail()
    }
    
    func sendMail() {
    
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["bboydais@gmail.com"])
        mailComposerVC.setSubject("café map 建議")
        mailComposerVC.setMessageBody("內容輸入在此~~~", isHTML: false)
        show(mailComposerVC, sender: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: tableViewDelegate & DataSource function
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 5
    }
    
    var locationCell = LocationCell()
    var otherCell = SearchMenuCell()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        // return different xib cell
        if indexPath.row == 0 {
            locationCell = slideMenu.menuTableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            
            locationCell.backgroundColor = .clear
            locationCell.titleLabel.text = conditionsList[indexPath.row]
            locationCell.locationLabel.text = userConditionsArr[indexPath.row]
            return locationCell
            
        } else {
            
            otherCell = slideMenu.menuTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchMenuCell
            otherCell.backgroundColor = .clear
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
    
    // MARK: DV function
    private let menuSwichPageScale: Float = 0.25
    var urlStr = String()
    var selectedCoordinate = CLLocationCoordinate2D()
    
    func showDetailView(notifcationInfo: Notification) {
        
        if slideMenu.frame.origin.x == 0 {
            slideMenu.callMenu()
        }
        
        if let status = notifcationInfo.object as? Bool {
            
            if status  {
                
                if let info = notifcationInfo.userInfo?["item"] as? CafeShopItem {
                    
                    storeName_Label.text = info.name
                    wifi_Label.text = info.wifi
                    seat_Label.text = info.seat
                    quiet_Label.text = info.quiet
                    cheap_Label.text = info.cheap
                    tasty_Label.text = info.tasty
                    music_Label.text = info.music
                    urlStr = info.urlStr
                    
                    if let lat = info.lat {
                        
                        selectedCoordinate.latitude = lat
                    }
                    if let lon = info.lon {
                        
                        selectedCoordinate.longitude = lon
                    }
                    
                    if info.urlStr == "" {
                        
                        officialBtn.isUserInteractionEnabled = false
                        officialBtn.titleLabel?.adjustsFontSizeToFitWidth = true
                        officialBtn.setTitle(" 未提供官網 ", for: .normal)
                    } else {
                        
                        officialBtn.isUserInteractionEnabled = true
                        officialBtn.setTitle("官網", for: .normal)
                    }
                    
                    print("info:\(info.name!)") 
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
    
    // 接到notification通知後 接收使用者搜尋的條件 並修改userConditionArr的內容
    func removeAlertView(notifcationInfo: Notification) {
        
        if let object = notifcationInfo.object as? Array<Any> {
            
            let changeIndex = object.first as! Int
            let option = object.last as! String
            userConditionsArr[changeIndex] = option
            print("arr:\(userConditionsArr)")
        }
        
        slideMenu.menuTableView.reloadData()
        alert.removeFromSuperview()
    }
    
    // DV BTN
    @IBAction func officialWebsiteBtnPressed(_ sender: UIButton) {
        
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let webVC = segue.destination as! WebViewController
        if segue.identifier == "webView" {
            
            webVC.urlStr = urlStr
            webVC.nameStr = self.storeName_Label.text!
            print("send")
        } else {
            
            webVC.urlStr = "https://cafenomad.tw/"
            webVC.nameStr = "Cafe Nomad官網"
        }
    }
    
    @IBAction func navigationBtnPressed(_ sender: UIButton) {
        
        let userPlace = MKPlacemark(coordinate: myLocation.coordinate, addressDictionary: nil)
        let shopPlace = MKPlacemark(coordinate: selectedCoordinate, addressDictionary: nil)
        let userItem = MKMapItem(placemark: userPlace)
        let shopItem = MKMapItem(placemark: shopPlace)
        userItem.name = "我的位置"
        shopItem.name = storeName_Label.text!
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        let itemArray = [userItem, shopItem]
        MKMapItem.openMaps(with: itemArray, launchOptions: options)
        
    }
    
    func downloadError() {
       
        print("下載失敗")
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: "資料下載失敗", message: "請檢查網路是否連線", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
