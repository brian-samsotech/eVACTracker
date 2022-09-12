//
//  userModel.swift
//  eVAS Tracker
//
//  Created by Brian on 10/6/21.
//

import Foundation

struct userModel : Codable {
    var empID : Int?
    var empCode : String?
    var fullName : String?
    var departmentName : String?
    var designationName : String?
    var employeeType : String?
    var vaccinatedDate : String?
    var vaccineName : String?
    var description : String?
    var riskCategory : String?
    var lastPCRDate : String?
    var lastPCRResult : String?
    var backInOffice : Bool?
    var noofDaysLastPCR : Int?
    var closeContactFlag : Int?
    var contactDate : String?
    var currentRiskCategory : String?
    var statusCategory : String?
    var empPhoto : String?

    enum CodingKeys: String, CodingKey {

        case empID = "EmpID"
        case empCode = "EmpCode"
        case fullName = "FullName"
        case departmentName = "DepartmentName"
        case designationName = "DesignationName"
        case employeeType = "EmployeeType"
        case vaccinatedDate = "VaccinatedDate"
        case vaccineName = "VaccineName"
        case description = "Description"
        case riskCategory = "RiskCategory"
        case lastPCRDate = "lastPCRDate"
        case lastPCRResult = "lastPCRResult"
        case backInOffice = "BackInOffice"
        case noofDaysLastPCR = "NoofDaysLastPCR"
        case closeContactFlag = "CloseContactFlag"
        case contactDate = "ContactDate"
        case currentRiskCategory = "CurrentRiskCategory"
        case statusCategory = "StatusCategory"
        case empPhoto = "EmpPhoto"
    }

   

}
