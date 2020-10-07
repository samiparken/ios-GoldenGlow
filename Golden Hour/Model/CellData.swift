//
//  CellData.swift
//  Golden Hour
//
//  Created by Sam on 10/7/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

// Data for TableViewCell
struct CellData {
    
    let time: Date?
    let timeString: String
    let state: Int
    let stateString: String
    let duration: String
    let isEvening: Bool
    let symbol: String
    
    // Timestamp Mode
    init(time: Date) {
        self.time = time
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        timeString = String(format: "%02d:%02d", hour, minute)
        
        self.state = INVALIDSTATE
        self.stateString = ""
        self.duration = ""
        self.isEvening = false
        self.symbol = ""
    }
    
    // Cell Mode
    init(state: Int, duration: String, isEvening: Bool)
    {
        self.time = nil
        self.timeString = ""
        self.state = state
        self.duration = duration
        self.isEvening = isEvening
        
        switch state {
        case DAYTIME: stateString = "DAYTIME";          symbol = ""
        case LOWSUN: stateString =  "LOW SUN";          symbol = "Symbol_lowsun"
        case GOLDENHOURP: stateString =  "GOLDEN HOUR +"; symbol = "Symbol_golden+"
        case SETRISE: stateString = isEvening ? "SUNSET" : "SUNRISE" ; symbol = "Symbol_setrise"
        case GOLDENHOURM: stateString =  "GOLDEN HOUR -" ; symbol = "Symbol_golden-"
        case BLUEHOUR: stateString =  "BLUE HOUR" ;         symbol = "Symbol_blue"
        case NIGHTTIME: stateString =  "NIGHTTIME";         symbol = ""
        default: stateString = "ERROR";                     symbol = ""
        }
    }
    
}
