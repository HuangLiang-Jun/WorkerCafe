//
//  Define.swift
//  WorkerCafe
//
//  Created by huang on 2017/1/8.
//  Copyright © 2017年 Huang. All rights reserved.
//

import Foundation

// menu 上 label 選項
let conditionsList = ["地區", "WIFI", "有座位", "安靜程度", "口味"]

let locationArr = [
    "全國",
    "宜蘭",
    "基隆",
    "台北",
    "桃園",
    "新竹",
    "苗栗",
    "台中",
    "彰化",
    "南投",
    "嘉義",
    "雲林",
    "台南",
    "高雄",
    "屏東",
    "台東",
    "花蓮"
]


let placesDict: Dictionary<String,String> = [
    
    "全國": "",
    "宜蘭": "yilan",
    "基隆": "keelung",
    "台北": "taipei",
    "桃園": "taoyuan",
    "新竹": "hsinchu",
    "苗栗": "miaoli",
    "台中": "taichung",
    "彰化": "changhua",
    "南投": "nantou",
    "嘉義": "chiayi",
    "雲林": "yunlin",
    "台南": "tainan",
    "高雄": "kaohsiung",
    "屏東": "pingtung",
    "台東": "taitung",
    "花蓮": "hualien"
]

let REMOVE_KEY_NAME = NSNotification.Name(rawValue: "removeView")
let DOWNLOAD_FINISH_KEY = NSNotification.Name(rawValue: "downLoadFinish")
let SHOW_DETAIL_VIEW_NAME = NSNotification.Name(rawValue: "showDetailName")
let YESTERDAY_USERDEFAULT_KEY = "yesterday"
let CAFESHOPDATA_USERDEFAULT_KEY = "cafeshopData"
let DOWNLOAD_ERROR_KEY = NSNotification.Name(rawValue: "downloadError")

enum UserSelectedStatus {
    case SelectedMark
    case SelectedMap
}
