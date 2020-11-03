//
//  AvatarHelper.swift
//  TimeBot
//
//  Created by QUANG on 3/13/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
