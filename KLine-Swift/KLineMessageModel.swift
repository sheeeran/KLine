//
//  KLineMessageModel.swift
//  KLine
//
//  Created by xieran on 2018/9/8.
//  Copyright © 2018年 xieran. All rights reserved.
//

import UIKit
import ObjectMapper

class KLineMessageModel: Mappable {
    var roomType: String?
    var msgType: String?
    var symbols: String?
    var period: String?
    var marketId: Int?

    required init?(map: Map) {

    }
    
    func mapping(map: Map) {
        roomType <- map["roomType"]
        msgType <- map["msgType"]
        symbols <- map["symbols"]
        period <- map["period"]
        marketId <- map["marketId"]
    }
}
