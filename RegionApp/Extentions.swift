//
//  Extentions.swift
//  RegionApp
//
//  Created by Nik Kozhemyakin on 22.08.2023.
//

import UIKit

extension UIColor {
    struct Colors {
        static let backPrimary = UIColor(named: "backPrimary")
        static let labelTertiary = UIColor(named: "labelTertiary")
        static let labelPrimary = UIColor(named: "labelPrimary")
        static let supportSeparator = UIColor(named: "supportSeparator")
        static let colorRed = UIColor(named: "colorRed")
        static let navigationColor = UIColor(named: "navigationColor")
    }
}

extension UIView {
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
//        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
 
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
