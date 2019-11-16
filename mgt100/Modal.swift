//
//  Modal.swift
//  mgt100
//
//  Created by Matheus Bustamante on 11/15/19.
//  Copyright © 2019 Innovation that excites. All rights reserved.
//

import Foundation

struct Months: Decodable {
    let month: [Days]
}

struct Days: Decodable {
    let day: [DetailDay]
}

struct DetailDay: Decodable {
    let readings: [String]
    let tas: [DetailTa]
}

struct Readings: Decodable {
    let readings: [String]
}

struct DetailTa: Decodable {
    let category: String?
    let time: String?
    let year: String?
    let description: String?
    let name: String?
}
