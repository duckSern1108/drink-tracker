//
//  UIColor+Ext.swift
//  SSTCloud
//
//  Created by Sern Duck on 11/03/2023.
//

import UIKit


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    convenience public init(hex: String) {
        let hexStringColor = (hex == "") ? "FF0000" : hex
        var cString:String = hexStringColor.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
        }
        
        let sLength = cString.count
        assert(sLength == 6 || sLength == 8, "Invalid string")
        
        var alpha: CGFloat = 1.0
        if sLength == 8 {
            alpha = CGFloat((cString.substring(from: cString.index(cString.endIndex, offsetBy: -2)) as NSString).floatValue)/100.0
            cString = cString.substring(to: cString.index(cString.endIndex, offsetBy: -2))
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(red:CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green:CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue:CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
    
    static let eCom = UIColor.init(red: 0.0/255.0, green: 144.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    static let eComHex = "00904A"
}
