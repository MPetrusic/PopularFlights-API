//
//  FlightsModel.swift
//  KiwiFlights
//
//  Created by Milos Petrusic on 19.4.21..
//

import Foundation

struct FlightsModel: Codable {
    let data: [FlightsDetails]
}

struct FlightsDetails: Codable {
    let cityFrom: String
    let cityTo: String
    let cityCodeFrom: String
    let cityCodeTo: String
    let mapIdto: String
    let price: Int
    let deep_link: String
    let dTime: Int
}
