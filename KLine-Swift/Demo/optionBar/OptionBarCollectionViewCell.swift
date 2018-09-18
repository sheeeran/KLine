//
//  OptionBarCollectionViewCell.swift
//  test
//
//  Created by xieran on 2018/9/17.
//  Copyright © 2018年 xieran. All rights reserved.
//

import UIKit
import SnapKit

class OptionBarCollectionViewCell: UICollectionViewCell {
    var btn: UIButton? {
        didSet {
            for v in contentView.subviews where v is UIButton {
                v.removeFromSuperview()
            }
            
            if let button = btn {
                contentView.addSubview(button)
                button.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
}
