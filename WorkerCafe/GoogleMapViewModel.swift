//
//  GoogleMapViewModel.swift
//  WorkerCafe
//
//  Created by huang on 2016/12/21.
//  Copyright © 2016年 Huang. All rights reserved.
//

import Foundation

import GoogleMaps

class GoogleMapViewModel:NSObject, GMSMapViewDelegate
{
    var googleMap:GMSMapView!

    func setup(userLocation:CLLocation) -> UIView {
        
        let camera =
            GMSCameraPosition.camera(
                withLatitude:userLocation.coordinate.latitude,
                longitude:userLocation.coordinate.longitude,
                zoom: 15)
        let mapFrame = UIScreen.main.bounds
        googleMap = GMSMapView.map(withFrame: mapFrame , camera: camera)
        googleMap.isMyLocationEnabled = true
        googleMap.settings.myLocationButton = true
        googleMap.delegate = self
        
        return googleMap
        
    }
    
    func addCoffeeShopLocation(info: Array<Any>) {
        
        if let itemArr = info as? Array<CafeShopItem> {
        
            for tmp in itemArr {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: tmp.lat, longitude: tmp.lon)
                marker.title = tmp.name
                marker.map = googleMap
                marker.userData = tmp
                
            }
        }
    }

    // 點大頭針
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

       // print(marker.title!)
         let shopInfo = marker.userData as! CafeShopItem
           let name = shopInfo.name ?? "nil"
            print("name:\(name)")
            print("wiff:\(shopInfo.wifi)")
        
        NotificationCenter.default.post(name: SHOW_DETAIL_VIEW_NAME, object: true, userInfo: ["item":shopInfo])
        // NotificationCenter.default.post(name: SHOW_DETAIL_VIEW_NAME, object: true)
        return false

    }

    // 點擊地圖
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    
        NotificationCenter.default.post(name: SHOW_DETAIL_VIEW_NAME, object: false)
    }

    func resetCafeshopMaekers(info: Array<Any>) {
        googleMap.clear()
        addCoffeeShopLocation(info: info)
    }
}
