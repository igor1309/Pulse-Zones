//
//  Zone.swift
//  Pulse Zones
//
//  Created by temp on 28.06.2020.
//

import SwiftUI

struct Zone : Identifiable {
    var id: Int
    var name: String
    var description: String
    var color: Color        //   ZoneColor
    var min: Double
    var max: Double
}
