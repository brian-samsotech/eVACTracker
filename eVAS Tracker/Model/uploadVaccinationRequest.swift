//
//  uploadVaccinationRequest.swift
//  eVAS Tracker
//
//  Created by Brian on 10/17/21.
//

import Foundation
struct uploadVaccinationRequest:Codable
{
    var FileBase64String: String?
    var EmployeeID: Int?
    var VaccineID: Int?
    var DoseID: Int?
    var VaccinationDateTime:String?
    var VaccinationName:String?
    var DoseNumber: Int?
}
