//
//  CGFLoat+Ext.swift
//  SSTCloud
//
//  Created by Sern Duck on 05/03/2023.
//

import Foundation

extension CGFloat {
    func convertMsToMinuteAndSecond() -> String {
        let minute = (self / 60000).rounded(.down)
        let seconds = (self - minute * 60000) / 1000
        let minuteDisplay = "\(Int(minute))"
        let intSec = Int(seconds)
        let secondsDisplay = intSec < 10 ? "0" + String(intSec) : String(intSec)
        return minuteDisplay + ":" + secondsDisplay
    }
}
