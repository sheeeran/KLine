//
//  UIDevice+Orientation.swift
//  test
//
//  Created by xieran on 2018/9/17.
//  Copyright © 2018年 xieran. All rights reserved.
//

import UIKit

extension UIDevice {
    static var isPortrait: Bool {
        return UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
    }
}
