//
//  KLineResponse.swift
//  KLine
//
//  Created by xieran on 2018/9/8.
//  Copyright © 2018年 xieran. All rights reserved.
//

import UIKit
import ObjectMapper

class KLineResponse: Mappable {
    var code: Int?
    var data: KLineDataModel?
    var type: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        data <- map["data"]
        type <- map["type"]
    }
}

class KLineDataModel: Mappable {
    var line: KLineModel?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        line <- map["kLine"]
    }
}

class KLineModel: Mappable {
//    1. t 时间戳
//    2. c 该时间段内收盘价
//    3. o 该时间段内开盘价
//    4. h 该时间段内最高价
//    5. l 该时间段内最低价
//    6. v 该时间段内交易量
    var ts: [Int]?
    var closePrice: [Double]?
    var openPrice: [Double]?
    var highestPrice: [Double]?
    var lowestPrice: [Double]?
    var tradeVolume: [Double]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        ts <- map["t"]
        closePrice <- map["c"]
        openPrice <- map["o"]
        highestPrice <- map["h"]
        lowestPrice <- map["l"]
        tradeVolume <- map["v"]
    }
}
