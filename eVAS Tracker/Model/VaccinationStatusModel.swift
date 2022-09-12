//
//  VaccinationStatusModel.swift
//  eVAS Tracker
//
//  Created by Brian on 10/17/21.
//

import Foundation
struct VaccinationStatusModel : Codable {
    var vaccineID : Int?
    var vaccineTypeID : Int?
    var batchNumber : String?
    var expiryDate : String?
    var vaccineName : String?

    enum CodingKeys: String, CodingKey {

        case vaccineID = "VaccineID"
        case vaccineTypeID = "VaccineTypeID"
        case batchNumber = "BatchNumber"
        case expiryDate = "ExpiryDate"
        case vaccineName = "VaccineName"
    }

    

}
