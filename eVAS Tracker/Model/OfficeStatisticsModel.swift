//
//  OfficeStatisticsModel.swift
//  eVAS Tracker
//
//  Created by Brian on 10/7/21.
//

import Foundation
struct OfficeStatisticsModel : Codable {
    var teamMembers : Int?
    var teamMembersInOffice : Int?
    var vaccineDone : Int?
    var notDone : Int?
    var notKnown : Int?
    var religiousmedicalCount : Int?
    var activeCases : Int?
    var reportedCases : Int?
    var activeCasesLast14Days : Int?

    enum CodingKeys: String, CodingKey {

        case teamMembers = "TeamMembers"
        case teamMembersInOffice = "TeamMembersInOffice"
        case vaccineDone = "VaccineDone"
        case notDone = "NotDone"
        case notKnown = "NotKnown"
        case religiousmedicalCount = "ReligiousmedicalCount"
        case activeCases = "ActiveCases"
        case reportedCases = "ReportedCases"
        case activeCasesLast14Days = "ActiveCasesLast14Days"
    }

    

}
