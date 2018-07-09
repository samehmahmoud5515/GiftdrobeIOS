//
//  MenuViewCustomizable.swift
//  PagingMenuController
//
//  Created by Yusuke Kita on 5/23/16.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation
import UIKit

public protocol MenuViewCustomizable {
    var backgroundColor: UIColor { get }
    var selectedBackgroundColor: UIColor { get }
    var height: CGFloat { get }
    var animationDuration: TimeInterval { get }
    var deceleratingRate: CGFloat { get }
    var selectedItemCenter: Bool { get }
    var displayMode: MenuDisplayMode { get }
    var focusMode: MenuFocusMode { get }
    var dummyItemViewsSet: Int { get }
    var menuPosition: MenuPosition { get }
    var dividerImage: UIImage? { get }
    var itemsOptions: [MenuItemViewCustomizable] { get }
}

public extension MenuViewCustomizable {
    var backgroundColor: UIColor {
        return UIColor(hexString: "#c62d2e")
    }
    var selectedBackgroundColor: UIColor {
        return UIColor(hexString: "#b02829")
    }
    var height: CGFloat {
        return 40
    }
    var animationDuration: TimeInterval {
        return 0.3
    }
    var deceleratingRate: CGFloat {
        return UIScrollViewDecelerationRateFast
    }
    var selectedItemCenter: Bool {
        return true
    }
    var displayMode: MenuDisplayMode {
        return .standard(widthMode: .flexible, centerItem: false, scrollingMode: .pagingEnabled)
    }
    var focusMode: MenuFocusMode {
        return .roundRect(radius: CGFloat(5), horizontalPadding: CGFloat(8), verticalPadding: CGFloat(8), selectedColor: UIColor.red)
    }
    var dummyItemViewsSet: Int {
        return 3
    }
    var menuPosition: MenuPosition {
        return .top
    }
    var dividerImage: UIImage? {
        return nil
    }
    
}

public enum MenuDisplayMode {
    case standard(widthMode: MenuItemWidthMode, centerItem: Bool, scrollingMode: MenuScrollingMode)
    case segmentedControl
    case infinite(widthMode: MenuItemWidthMode, scrollingMode: MenuScrollingMode)
}

public enum MenuItemWidthMode {
    case flexible
    case fixed(width: CGFloat)
}

public enum MenuScrollingMode {
    case scrollEnabled
    case scrollEnabledAndBouces
    case pagingEnabled
}

public enum MenuFocusMode {
    case none
    case underline(height: CGFloat, color: UIColor, horizontalPadding: CGFloat, verticalPadding: CGFloat)
    case roundRect(radius: CGFloat, horizontalPadding: CGFloat, verticalPadding: CGFloat, selectedColor: UIColor)
}

public enum MenuPosition {
    case top
    case bottom
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
