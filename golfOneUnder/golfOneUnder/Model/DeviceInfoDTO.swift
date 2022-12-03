//
//  DeviceInfoDTO.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 12/1/22.
//

import Foundation

struct DeviceInfoDTO: Decodable, Encodable {
    var deviceName: String = ""
    var deviceLatitude: Double = 0.0
    var deviceLongitude: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case deviceName
        case deviceLatitude
        case deviceLongitude
    }
}
