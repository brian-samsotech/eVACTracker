//
//  NotifyHRModel.swift
//  eVAS Tracker
//
//  Created by Brian on 10/10/21.
//

import Foundation
struct NotifyHRModel:Codable
{
    var CloseContactDetails: String?
    var EmployeeID: Int?
    var CloseContactDate: String?
    var AreyouFeelingGoodToday: Bool?
    var AreyouCoviPositive: Bool?
    var DoYouHaveAnySymptoms: Bool?
   
    
}
