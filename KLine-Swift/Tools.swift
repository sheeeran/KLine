//
//  Tools.swift
//  KLine-Swift
//
//  Created by xieran on 2018/9/17.
//  Copyright © 2018年 xieran. All rights reserved.
//

import Foundation

enum DeviceOrientation {
    case landspape
    case portrait
}

struct Tools {
    static var orientation: DeviceOrientation {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            return .landspape
        case .portrait, .portraitUpsideDown:
            return .portrait
        default:
            return .portrait
        }
    }
}

